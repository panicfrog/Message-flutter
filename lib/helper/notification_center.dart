typedef NotificaitonCallBack = void Function({dynamic body});

class NotificationCenter {
  static NotificationCenter _default = NotificationCenter._internal();
  factory NotificationCenter() => _default;
  NotificationCenter._internal();

  final Map<String, _Notification> notifications = Map();

  void send(String notificationName, {dynamic body}) {
    if (notifications.containsKey(notificationName)) {
      notifications[notificationName].callBacks.forEach((n) {
        if (body != null) {
          n.callBack(body: body);
        } else {
          n.callBack();
        }
      });
    } else {
      assert(false, "$notificationName 不存在");
    }
  }

  void addObserver(String name, Object observer,  NotificaitonCallBack callback) {
    if (!notifications.containsKey(name)) {
      _Notification noti = _Notification(name);
      notifications[name] = noti;
    }
    _Notification n = notifications[name];
    _NotificationCallBackObject c = _NotificationCallBackObject(observer, callback);
    n.callBacks.add(c);
  }

  void removeObserver(Object observer, {String key}) {
    notifications.forEach((k, v) {
      if (key != null && key.length > 0 && k != key) {
      } else {
        v.callBacks.removeWhere((c) {
          return c.object == observer;
        });
      }
    });
  }
  
}

class _Notification {
  final String name;
  final List<_NotificationCallBackObject> callBacks = [];
  _Notification(String name): this.name = name;
}

class _NotificationCallBackObject {
  Object object;
  NotificaitonCallBack callBack;
  _NotificationCallBackObject(Object object, NotificaitonCallBack callBack): this.object = object, this.callBack = callBack;
}