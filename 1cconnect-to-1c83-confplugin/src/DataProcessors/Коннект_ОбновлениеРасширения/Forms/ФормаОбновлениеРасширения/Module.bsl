
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Описание
// 
// Параметры:
// 	Отказ - Булево - Описание
// 	СтандартнаяОбработка - Булево - Описание
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	МассивРасширений = РасширенияКонфигурации.Получить(Новый Структура("Имя", "BotPlatform"));

	Если МассивРасширений.Количество() = 0 Тогда

		Описание = "Расширение не установлено";
		ТекущаяВерсияРасширения = "неопределено";

	Иначе

		ТекущаяВерсияРасширения = МассивРасширений[0].Версия;

	КонецЕсли;

	ЗаполнитьДеревоРелизовНаСервере();

КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы

// Описание
// 
// Параметры:
// 	Элемент - ДекорацияФормы - Описание
&НаКлиенте
Процедура КартинкаСкачатьНажатие(Элемент)

	Если Найти(Описание, "новая") Тогда

		СкачатьРасширение(ПутьКОбновлению);

	КонецЕсли;

КонецПроцедуры

// Описание
// 
// Параметры:
// 	Элемент - ДекорацияФормы - Описание
&НаКлиенте
Процедура КартинкаОбновитьНажатие(Элемент)

	Если Найти(Описание, "новая") Тогда

		ОбновитьРасширениеМаксимальное(ПутьКОбновлению);

	КонецЕсли;

КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Описание
// 
// Параметры:
&НаСервере
Процедура ЗаполнитьДеревоРелизовНаСервере()

	ОписаниеОшибки = "";

	СписокСсылок.Очистить();

	ЭлементыДерева = ДеревоРелизов.ПолучитьЭлементы();

	Для каждого ЭлементДерева Из ЭлементыДерева Цикл
		ЭлементыДерева.Удалить(ЭлементДерева);
	КонецЦикла;

	Результат = ПолучитьДанныеССервера1СКоннект(ОписаниеОшибки, Ложь);

	Если Результат = Неопределено Тогда
		ТекущаяВерсияVersion = ТекущаяВерсияРасширения;
		ПутьРасширения = "";
	Иначе
		ТекущаяВерсияVersion = Результат.ВерсияФайлаОбновления;
		ПутьРасширения = Результат.Данные.Получить("PrimaryDownloadLink");
	КонецЕсли;

	ПутьКОбновлению = ПутьРасширения;

	КорневойЭлемент = ДеревоРелизов.ПолучитьЭлементы().Добавить();
	КорневойЭлемент.НомерВерсии = ТекущаяВерсияVersion;
	КорневойЭлемент.Обновить = Истина;
	КорневойЭлемент.Скачать = Истина;

	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ТекущаяВерсияРасширения, ТекущаяВерсияVersion) = 0 Тогда

		Описание = "Текущий релиз актуален.";
		Элементы.Описание.ЦветТекста = WebЦвета.ЗеленыйЛес;
		Элементы.КартинкаОбновить.Видимость = Ложь;
		Элементы.КартинкаСкачать.Видимость = Ложь;

	Иначе

		Описание = "Доступна новая версия: " + ТекущаяВерсияVersion;
		Элементы.Описание.ЦветТекста = WebЦвета.КрасноФиолетовый;
		Элементы.КартинкаОбновить.Видимость = Истина;
		Элементы.КартинкаСкачать.Видимость = Истина;

	КонецЕсли;

КонецПроцедуры

// Описание
// 
// Параметры:
// 	АдресХранилища
// 	ОписаниеОшибки - Строка - Описание
// 	УстановленнаяВерсия - Строка - Описание
&НаСервереБезКонтекста
Процедура ОбновитьРасширениеНаСервере(АдресХранилища, ОписаниеОшибки,
	УстановленнаяВерсия)
	
	УстановленнаяВерсия = Коннект_Автообновление.ОбновитьРасширение(АдресХранилища);
	
	Если УстановленнаяВерсия = "" Тогда
		ОписаниеОшибки = "Обновление расширения не удалось, требуется монопольный режим";
	КонецЕсли;
	
КонецПроцедуры

// Описание
// 
// Параметры:
// 	URL - Строка - Описание
&НаКлиенте
Процедура СкачатьРасширение(URL);

	ОписаниеОшибки = "";

	СтруктураРезультата = ПолучитьДанныеССервера1СКоннект(ОписаниеОшибки, Истина);

	Если НЕ ЗначениеЗаполнено(СтруктураРезультата.ОписаниеОшибки) Тогда

		АдресХранилища = ПолучитьДанныеССервера1СКоннект(ОписаниеОшибки, Истина).Файл;

		Если АдресХранилища = Неопределено Тогда

			АдресХранилища = ПолучитьФайлНаСервере(URL, ОписаниеОшибки);

		КонецЕсли;

		Если НЕ АдресХранилища = Неопределено Тогда

			ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
			ДиалогВыбораФайла.ПолноеИмяФайла = nameFile;
			ДиалогВыбораФайла.Расширение = "cfe";
			ОписаниеОповещения = Новый ОписаниеОповещения("Подключаемый_ПриЗакрытииВыбораФайла", ЭтотОбъект, АдресХранилища);
			ДиалогВыбораФайла.Показать(ОписаниеОповещения);

		Иначе

			Сообщить(ОписаниеОшибки);

		КонецЕсли;

	Иначе

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтруктураРезультата.ОписаниеОшибки);

	КонецЕсли;

КонецПроцедуры

// Описание
// 
// Параметры:
// 	ВыбранныеФайлы
// 	ДопПараметры
&НаКлиенте
Процедура Подключаемый_ПриЗакрытииВыбораФайла(ВыбранныеФайлы,
		ДопПараметры) Экспорт

	Если НЕ ВыбранныеФайлы = Неопределено Тогда

		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДопПараметры);

		Попытка

			ДвоичныеДанные.Записать(ВыбранныеФайлы[0]);

		Исключение

			Сообщить(ОписаниеОшибки());

		КонецПопытки;

	КонецЕсли;

КонецПроцедуры

// Описание
// 
// Параметры:
// 	URL - Строка - Описание
&НаКлиенте
Процедура ОбновитьРасширениеМаксимальное(URL)

	ОписаниеОшибки = "";

	СтруктураРезультата = ПолучитьДанныеССервера1СКоннект(ОписаниеОшибки, Истина);

	Если НЕ ЗначениеЗаполнено(СтруктураРезультата.ОписаниеОшибки) Тогда

		АдресХранилища = СтруктураРезультата.Данные;

		Если АдресХранилища = Неопределено Тогда

			АдресХранилища = ПолучитьФайлНаСервере(URL, ОписаниеОшибки);

		КонецЕсли;

		Если НЕ АдресХранилища = Неопределено Тогда

			УстановленнаяВерсия = "";
			ОбновитьРасширениеНаСервере(СтруктураРезультата.Файл, ОписаниеОшибки, УстановленнаяВерсия);

			Если НЕ ПустаяСтрока(ОписаниеОшибки) Тогда

				Сообщить(ОписаниеОшибки);

			Иначе

				Сообщить("Обновление расширения выполнено успешно.");

				ТекущаяВерсияРасширения = СтруктураРезультата.ВерсияФайлаОбновления;

				Описание = "Текущий релиз актуален.";
				Элементы.Описание.ЦветТекста = WebЦвета.ЗеленыйЛес;
				Элементы.КартинкаОбновить.Видимость = Ложь;
				Элементы.КартинкаСкачать.Видимость = Ложь;

			КонецЕсли;
		Иначе

			Сообщить(ОписаниеОшибки);

		КонецЕсли;

	Иначе

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтруктураРезультата.ОписаниеОшибки);

	КонецЕсли;

КонецПроцедуры

// Описание
// 
// Параметры:
// 	ОписаниеОшибки - Строка - Описание
// 	СкачатьФайл - Булево - Описание
// Возвращаемое значение:
// 	Структура, Структура, Неопределено, Структура, Структура, Структура, Структура - Описание:
// * ВерсияФайлаОбновления 
// * Данные 
// * Файл 
// * ОписаниеОшибки 
&НаСервере
Функция ПолучитьДанныеССервера1СКоннект(ОписаниеОшибки, СкачатьФайл)

	Результат = Коннект_Автообновление.ПолучитьФайлОбновления(СкачатьФайл);

	Если Результат = Неопределено Тогда

		ОписаниеОшибки = "Произошла сетевая ошибка!";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки);

		Возврат Неопределено;

	КонецЕсли;

	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;

	Если Результат.Файл.КодСостояния = 200 Тогда

		Если СкачатьФайл Тогда

			ТелоФайла = Результат.Файл.ПолучитьТелоКакДвоичныеДанные();

			ТелоФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(ТелоФайла);

			MD5Файла = Коннект_ОбщегоНазначения.ПолучитьСуммуMD5Файла(ТелоФайла, Истина);

			Если Результат.Данные.Получить("MD5") = MD5Файла Тогда

				СтруктураРезультата = Коннект_Автообновление.ПустаяСтруктураФайлаОбновления();
				СтруктураРезультата.ВерсияФайлаОбновления = Результат.ВерсияФайлаОбновления;
				СтруктураРезультата.Файл = ТелоФайлаВоВременномХранилище;
				СтруктураРезультата.Данные = Результат.Данные;
				nameFile = СтруктураРезультата.Данные.Получить("Name");

				Возврат СтруктураРезультата;

			Иначе

				СтруктураРезультата = Коннект_Автообновление.ПустаяСтруктураФайлаОбновления();
				СтруктураРезультата.ОписаниеОшибки = "Различаются контрольные суммы файла описания релиза и файла обновления, скачивание или обновление выполнено не будет";

				Возврат СтруктураРезультата;

			КонецЕсли;

		Иначе

			ТекстJSON = Результат.Файл.ПолучитьТелоКакСтроку();

			СтруктураРезультата = Коннект_Автообновление.ПустаяСтруктураФайлаОбновления();
			СтруктураРезультата.ВерсияФайлаОбновления = Результат.ВерсияФайлаОбновления;
			СтруктураРезультата.Файл = ТекстJSON;
			СтруктураРезультата.Данные = Результат.Данные;

			Возврат СтруктураРезультата;

		КонецЕсли

	Иначе

		ОписаниеОшибки = "Файл не найден.";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки);

		Возврат Неопределено;

	КонецЕсли;

КонецФункции

// Описание
// 
// Параметры:
// 	URL - Строка, Строка - Описание
// 	ОписаниеОшибки - Строка - Описание
// Возвращаемое значение:
// 	
&НаСервере
Функция ПолучитьФайлНаСервере(URL, ОписаниеОшибки)

	Возврат ПолучитьДанныеССервера1СКоннект(ОписаниеОшибки, Истина).Файл;

КонецФункции
#КонецОбласти

