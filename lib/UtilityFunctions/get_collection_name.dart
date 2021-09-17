String getCollectionName(int sender, int receiver) {
  int value = sender.compareTo(receiver);
  if (value < 0) {
    return '$sender-$receiver';
  } else {
    return '$receiver-$sender';
  }
}
