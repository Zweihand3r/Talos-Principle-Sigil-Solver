#ifndef HELPERS_H
#define HELPERS_H

#include <QObject>
#include <QColor>

class Helpers : public QObject
{
    Q_OBJECT
public:
    explicit Helpers(QObject *parent = nullptr);

    Q_INVOKABLE int getLightness(const QString &colorStr);

signals:

public slots:
};

#endif // HELPERS_H
