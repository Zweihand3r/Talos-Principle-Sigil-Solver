#include "helpers.h"

Helpers::Helpers(QObject *parent) : QObject(parent)
{

}

int Helpers::getLightness(const QString &colorStr)
{
    QColor *color = new QColor(colorStr);
    return color->lightness();
}
