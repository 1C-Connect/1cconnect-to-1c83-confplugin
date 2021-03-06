Функция СведенияОВнешнейОбработке() Экспорт

	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("Вид", "ДополнительнаяОбработка");
	ПараметрыРегистрации.Вставить("Наименование", "Коннект: Регламентная операция удаление восстановление пользователей"); //Наименование обработки, которым будет заполнено наименование элемента справочника
	ПараметрыРегистрации.Вставить("Версия", "1.0");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Информация", "Обработка выполняет регламентная операция удаление восстановление пользователей"); //Краткая информация по обработке, описание обработки
	ПараметрыРегистрации.Вставить("ВерсияБСП", "2.4.6.207");
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	ДобавитьКоманду(ТаблицаКоманд, "Коннект: Регламентная операция удаление восстановление пользователей", //представление команды в пользовательском интерфейсе
		"РегламентнаяОперацияУдалениеВосстановлениеПользователей", //идентификатор команды; любая строка, уникальная в пределах данной обработки
		"ВызовСерверногоМетода");
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	Возврат ПараметрыРегистрации;

КонецФункции

Функция ПолучитьТаблицуКоманд()

	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));

	Возврат Команды;

КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор,
		Использование, ПоказыватьОповещение = Ложь, Модификатор = "")

	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;

КонецПроцедуры

Процедура ВыполнитьКоманду(ИдентификаторКоманды,
		ПараметрыВыполненияКоманды) Экспорт

		// Реализация логики команды
	Если ИдентификаторКоманды = "РегламентнаяОперацияУдалениеВосстановлениеПользователей" Тогда

		РасширенияКонфигурации.ВыполнитьФоновоеЗаданиеСРасширениямиБазыДанных("Коннект_ПрограммныйИнтерфейс.ОбработатьДанныеПоСотрудникам");

	КонецЕсли;

КонецПроцедуры