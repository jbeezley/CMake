#include <QObject>

class OtherObject : public QObject {
  Q_OBJECT
public:
  OtherObject() {}
private slots:
  void activated();
};
