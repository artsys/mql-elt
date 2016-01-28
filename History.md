# История изменений #

Под ссылкой на скачивание <b>жирным</b> шрифтом указывается номер issue который выполнен в этом релизе

[2.0.05 2012.03.04](http://code.google.com/p/mql-elt/downloads/detail?name=eLT_2012.03.04_2.0.05.exe&can=2&q=#makechanges)
  * - Исправлен расчет расширения таргетов (mgp\_TargetPlus)

[2.0.04 2012.02.28](http://code.google.com/p/mql-elt/downloads/detail?name=eLT_2012.02.29_2.0.04.exe&can=2&q=#makechanges)
  * - Прошло много изменений.
    * = Перешли на инсталлятор NSIS
    * + Закрытие по фикс. прибыли.
    * = Исправлен механизм закрытия по проценту
    * + Блок открытия по Червяку

[2.0.1 0202\_15](http://code.google.com/p/mql-elt/downloads/detail?name=eLT_201_0202_15.exe&can=2&q=#makechanges)
  * - Перешли на версию 2.0 <i>предыдущие версии не поддерживаются</i>

[1.1.1 0119\_12](http://code.google.com/p/mql-elt/downloads/detail?name=eLT_111_0119_12.exe&can=2&q=#makechanges)

  * - Подключен модуль расчета автолота
<i>Требуется проверка</i>


[1.0.9 0704\_15](http://code.google.com/p/mql-elt/downloads/detail?name=Setup_eLT_109_0704_15.exe&can=2&q=#makechanges)
  * <b>37</b>
    * - Исправлено ошибочное удаление отложенных ордеров выставленных вручную. (<i>желателен комментарий</i> <b>"@ip1"</b>)
    * - Добавлена возможность исключить ордер из обработки советником.
Для этого используется <b>"@exp_off"</b> в комментарии ордера. <i>Требуется проверка</i>


[1.0.9 0627\_23](http://code.google.com/p/mql-elt/downloads/detail?name=Setup_eLT_109_0627_23.exe&can=2&q=#makechanges)
  * - Добавлен метод открытия родителя для лимитной сетки.

[1.0.9 0627\_11](http://code.google.com/p/mql-elt/downloads/detail?name=Setup_eLT_109_0627_11.exe&can=2&q=#makechanges)
  * <b>33</b> - Если уровень сетки меньше максимального рыночного уровня, то отложенные дочерние ордера не выставляются.

[1.0.9 0612\_02](http://code.google.com/p/mql-elt/downloads/detail?name=Setup_eLT_109_0612_02.exe&can=2&q=#makechanges)
  * <b>33</b> - Критическое обновление.


[1.0.9 0609\_09](http://code.google.com/p/mql-elt/downloads/detail?name=Setup_eLT_109_0609_09.exe&can=2&q=#makechanges)
  * <b>33</b> - Изменения связанные с этим багфиксом

[1.0.9 0605\_12](http://code.google.com/p/mql-elt/downloads/detail?name=Setup_eLT_109_0605_12.exe&can=2&q=#makechanges)
  * <b>32</b> - Добавлено автооткрытие по барам.

[1.0.9 0526\_09](http://code.google.com/p/mql-elt/downloads/detail?name=Setup_eLT_109_0526_09.exe&can=2&q=#makechanges)
  * <b>28</b> - Исправлен баг с удалением отложенников, выставленных вручную, при МН = 0.

[1.0.9 0511\_12](http://code.google.com/p/mql-elt/downloads/detail?name=Setup_eLT_109_0511_12.exe&can=2&q=#makechanges)
  * Добавлено простое закрытие по ГроуЭквити

[1.0.8 4128\_12](http://code.google.com/p/mql-elt/downloads/detail?name=Setup_eLT_108_0428_12.exe&can=2&q=#makechanges)

  * <b>20</b>, <b>22</b> - добавлен контроль по выставленным объемам уровня.

[1.0.7 0423\_20](http://code.google.com/p/mql-elt/downloads/detail?name=Setup_eLT_107_0423_20.exe&can=2&q=#makechanges)

  * - Исправлен расчет ТП для открытых уровней сетки

[1.0.6 0419\_22](http://code.google.com/p/mql-elt/downloads/detail?name=Setup_eLT_106_0419_23.exe&can=2&q=#makechanges)

  * - Ошибка компиляции

[1.0.6 0419\_10](http://code.google.com/p/mql-elt/downloads/detail?name=Setup_eLT_106_0419_10.exe&can=2&q=#makechanges)
  * <b>12,13</b> - ошибка выставления добавочных ордеров.

  * <b>14</b>    - добавлена настройка <i><a href='http://code.google.com/p/mql-elt/wiki/Settings_EA_ALL#%D0%9D%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B9%D0%BA%D0%B0_%D1%81%D1%82%D0%BE%D0%BF%D0%BE%D0%B2%D1%8B%D1%85_%D0%BE%D1%80%D0%B4%D0%B5%D1%80%D0%BE%D0%B2'>SO_TP_on_first</a></i>

[1.0.6 0411\_22](http://code.google.com/p/mql-elt/downloads/detail?name=Setup_eLT_106_0412_22.exe&can=2&q=#makechanges)
  * <b>9</b> - Добавлен <i><a href='http://code.google.com/p/mql-elt/wiki/Settings_EA_ALL?ts=1302878444&updated=Settings_EA_ALL#%D0%9D%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B9%D0%BA%D0%B0_%D0%B4%D0%BE%D0%B1%D0%B0%D0%B2%D0%BE%D1%87%D0%BD%D0%BE%D0%B3%D0%BE_%D1%81%D1%82%D0%BE%D0%BF%D0%BE%D0%B2%D0%BE%D0%B3%D0%BE_%D0%BE%EF%BF%BD'>Добавочный стоповый ордер</a></i>