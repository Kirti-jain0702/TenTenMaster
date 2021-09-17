import 'package:delivoo/Auth/BLOC/auth_bloc.dart';
import 'package:delivoo/Auth/BLOC/auth_state.dart';
import 'package:delivoo/Components/custom_dialog.dart';
import 'package:delivoo/HomeOrderAccount/Order/Blocs/OrderBloc/orders_bloc.dart';
import 'package:delivoo/HomeOrderAccount/Order/Blocs/OrderBloc/orders_event.dart';
import 'package:delivoo/HomeOrderAccount/Order/Blocs/OrderBloc/orders_state.dart';
import 'package:delivoo/HomeOrderAccount/Order/UI/order_card.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderBodyState createState() => _OrderBodyState();
}

class _OrderBodyState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              AppLocalizations.of(context).getTranslationOf("my_account"),
              style: Theme.of(context).textTheme.bodyText1),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Theme.of(context).secondaryHeaderColor,
            tabs: [
              Tab(text: AppLocalizations.of(context).orders),
              Tab(text: AppLocalizations.of(context).past),
            ],
          ),
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return TabBarView(
                children: [
                  BlocProvider<OrdersBloc>(
                    create: (context) => OrdersBloc.orderList(true),
                    child: OrdersTab(),
                  ),
                  BlocProvider<OrdersBloc>(
                    create: (context) => OrdersBloc.orderList(false),
                    child: OrdersTab(),
                  )
                ],
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context).notLogin),
                    FlatButton(
                        onPressed: () {
                          showCustomDialog(context,
                              content: AppLocalizations.of(context)
                                  .getTranslationOf('do_you_want_to_login'));
                        },
                        child: Text(AppLocalizations.of(context).login))
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class OrdersTab extends StatefulWidget {
  @override
  _OrdersTabState createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab>
    with AutomaticKeepAliveClientMixin {
  OrdersBloc _orderBloc;
  bool _triggeredPagination = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _orderBloc = BlocProvider.of<OrdersBloc>(context);
    _orderBloc.add(FetchOrdersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        _orderBloc.add(FetchOrdersEvent());
      },
      child: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, orderState) {
          if (orderState is SuccessOrdersState) {
            _triggeredPagination = false;
            if (orderState.orders != null && orderState.orders.isNotEmpty)
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: orderState.orders.length,
                  itemBuilder: (context, index) {
                    if (!_triggeredPagination &&
                        index == orderState.orders.length - 1) {
                      _orderBloc.add(PaginateOrdersEvent());
                      _triggeredPagination = true;
                    }
                    return OrderCard(orderState.orders[index]);
                  },
                ),
              );
            else
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)
                        .getTranslationOf('no_orders_found')),
                    FlatButton(
                      onPressed: () => _orderBloc.add(FetchOrdersEvent()),
                      child: Text(AppLocalizations.of(context)
                          .getTranslationOf('refresh')),
                    ),
                  ],
                ),
              );
          } else if (orderState is LoadingOrdersState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text(AppLocalizations.of(context).networkError),
            );
          }
        },
      ),
    );
  }
}
