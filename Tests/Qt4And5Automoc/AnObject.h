#include <QObject>

class AnObject : public QObject {
  Q_OBJECT
public:
  AnObject() {}
private slots:
  void activated();
};
