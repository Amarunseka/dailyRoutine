# dailyRoutine – приложение планировщик учебного расписания.

### Рассчитано на студентов и учеников, но также может быть использовано как планировщик задач. Позволяет планировать расписание занятий и составлять список задач, а также хранить контакты (друзей и преподавателей).

## Состоит из трех основных блоков: 
- Расписание занятий. 
- Список задач. 
- Список контактов.

![schedule](https://github.com/Amarunseka/dailyRoutine/blob/main/assets/Small/ScheduleMainViewBC.png)
![tasks](https://github.com/Amarunseka/dailyRoutine/blob/main/assets/Small/TasksMainViewBC.png)
![contacts](https://github.com/Amarunseka/dailyRoutine/blob/main/assets/Small/ContactsMainView.png)

### Расписание занятий. 
На главном экране отображается календарь в развернутом или свернутом виде.
При выборе даты на календаре,  отображаются запланированные события на выбранную дату с указанием:
- названия
- времени
- имя преподавателя
- тип события
- место проведения (строение и аудитория)

При выборе события открывается экран редактирования.

Добавление нового события осуществляется путем нажатия на кнопку «плюс» в правом верхнем углу (открывается экран добавления события)
Выбор преподавателя осуществляется из заранее сохраненных преподавателей в разделе контакты.
Можно промаркировать событие цветом. Цвет события выбирается из семи предлагаемых цветов. 
Возможно запланировать занятие как на определенную дату единовременно, так  и установить повтор каждые семь дней. 
___

### Планировщик задач.
На главном экране отображается календарь в развернутом или свернутом виде.
При выборе даты на календаре,  отображаются запланированные задачи на выбранную дату с указанием:
- названия
- описания задачи
- статусом выполнено/невыполненно
При выборе задачи открывается экран редактирования.
Удаление осуществляется свайпом влево.

Добавление новой задачи осуществляется путем нажатия на кнопку «плюс» в правом верхнем углу (открывается экран добавления события).
Можно промаркировать задачу цветом.
___

### Контакты.
На главном экране отображаются сохраненные контакты по группам: преподаватели и друзья. 
Есть возможность поиска контактов по содержанию символов.
При выборе контакта открывается экран редактирования.
Удаление осуществляется свайпом влево.

Добавление нового контакта осуществляется путем нажатия на кнопку «плюс» в правом верхнем углу (открывается экран добавления события)
При добавлении контакта указывается его имя, телефонный номер, email, тип контакта (друг или учитель). Также можно установить картинку контакта из галереи или камеры.

## Техническая часть.
Проект выполнен на архитектуре MVC

C использованием фреймворков:

- Realm Studio – для хранения сохраненных данных.

- FSCalendar – для отображения работы с календарём.

Для выбора даты и времени  используется datePicker.

Экраны выполнены на базе таблиц.
