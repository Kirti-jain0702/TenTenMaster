import 'dart:async';
import 'dart:convert';

import 'package:delivoo/HomeOrderAccount/ProductRepository/product_repository.dart';
import 'package:delivoo/JsonFiles/Auth/Responses/user_info.dart';
import 'package:delivoo/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo/JsonFiles/base_list_response.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';

import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  ProductRepository _repository = ProductRepository();
  StreamSubscription<Event> _ordersStreamSubscription, _orderStreamSubscription;
  List<OrderData> _orders;
  OrderData _order;
  int _page = 1;
  bool _allDone = false, _isLoading = false;
  bool _isOrdersNew;

  OrdersBloc.orderList(this._isOrdersNew) : super(LoadingOrdersState());

  OrdersBloc.orderDetail(this._order) : super(OrderSuccess(_order));

  @override
  Future<void> close() async {
    await _unRegisterOrdersUpdates();
    await _unRegisterOrderUpdates();
    return super.close();
  }

  @override
  Stream<OrdersState> mapEventToState(OrdersEvent event) async* {
    if (event is FetchOrdersEvent) {
      yield* _mapFetchPastOrdersToState(1);
    } else if (event is PaginateOrdersEvent) {
      if (!_isLoading && !_allDone) {
        yield* _mapFetchPastOrdersToState(_page + 1);
      } else {
        print("all caught up");
      }
    } else if (event is FetchOrderUpdatesEvent) {
      _registerOrderUpdates();
    } else if (event is OrderUpdatedEvent) {
      yield* _updateOrder(event.orderData);
    }
  }

  Stream<OrdersState> _mapFetchPastOrdersToState(int page) async* {
    yield LoadingOrdersState();
    if (_orders == null || page == 1) {
      _orders = [];
    } else {
      _orders.add(OrderData.loadingOrder());
      yield SuccessOrdersState(_orders);
    }
    _isLoading = true;
    try {
      BaseListResponse<OrderData> orderRes = _isOrdersNew
          ? await _repository.getOrdersNew(page)
          : await _repository.getOrdersPast(page);
      if (_orders.isNotEmpty && _orders[_orders.length - 1].isLoadingOrder()) {
        _orders.removeAt(_orders.length - 1);
      }
      for (OrderData orderData in orderRes.data) orderData.setup();
      _page = orderRes.meta.current_page;
      _allDone = orderRes.meta.current_page == orderRes.meta.last_page;
      _isLoading = false;
      yield LoadingOrdersState();
      _orders.addAll(orderRes.data);
      yield SuccessOrdersState(_orders);
      await _registerOrdersUpdates();
    } catch (e) {
      print(e);
      _isLoading = false;
      yield FailureOrdersState(e);
    }
  }

  Stream<OrdersState> _updateOrder(OrderData orderUpdated) async* {
    try {
      if (_order != null &&
          Moment.parse(orderUpdated.updatedAt).date.millisecondsSinceEpoch >
              Moment.parse(_order.updatedAt).date.millisecondsSinceEpoch) {
        yield LoadingOrdersState();
        _order = orderUpdated;
        yield OrderSuccess(_order);
      } else if (_orders != null) {
        int index = -1;
        for (int i = 0; i < _orders.length; i++) {
          if (_orders[i].id == orderUpdated.id) {
            index = i;
            break;
          }
        }
        if (index != -1 &&
            Moment.parse(orderUpdated.updatedAt).date.millisecondsSinceEpoch >
                Moment.parse(_orders[index].updatedAt)
                    .date
                    .millisecondsSinceEpoch) {
          yield LoadingOrdersState();
          _orders[index] = orderUpdated;
          yield SuccessOrdersState(_orders);
        }
      }
    } catch (e) {
      print("_updateOrder: $e");
    }
  }

  Future<void> _registerOrdersUpdates() async {
    if (_ordersStreamSubscription == null) {
      final prefs = await SharedPreferences.getInstance();
      UserInformation userMe =
          UserInformation.fromJson(jsonDecode(prefs.get('user_info')));
      _ordersStreamSubscription = _repository
          .getOrdersFirebaseDbRef(userMe.id)
          .listen((Event event) => _handleFireEvent(event));
    }
  }

  Future<void> _registerOrderUpdates() async {
    if (_order == null || _order.user == null) return;
    if (_orderStreamSubscription == null) {
      _orderStreamSubscription = _repository
          .getOrderFirebaseDbRef(_order.user.id, _order.id)
          .listen((Event event) => _handleFireEvent(event));
    }
  }

  _unRegisterOrdersUpdates() async {
    if (_ordersStreamSubscription != null) {
      await _ordersStreamSubscription.cancel();
      _ordersStreamSubscription = null;
    }
  }

  _unRegisterOrderUpdates() async {
    if (_orderStreamSubscription != null) {
      await _orderStreamSubscription.cancel();
      _orderStreamSubscription = null;
    }
  }

  _handleFireEvent(Event event) {
    if (event.snapshot != null && event.snapshot.value != null) {
      try {
        Map requestMap = event.snapshot.value;
        OrderData orderUpdated = OrderData.fromJson(
            requestMap.containsKey("data") ? requestMap["data"] : requestMap);
        if (orderUpdated != null &&
            orderUpdated.id != null &&
            orderUpdated.status != null) {
          add(OrderUpdatedEvent(orderUpdated));
        }
      } catch (e) {
        print("requestMapCastError: $e");
      }
    }
  }
}
