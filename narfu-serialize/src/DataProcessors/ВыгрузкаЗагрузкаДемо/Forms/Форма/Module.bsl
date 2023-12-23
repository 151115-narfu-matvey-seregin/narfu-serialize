
&НаКлиенте
Асинх Процедура Загрузка(Команда)
	
	ПараметрыДиалога = Новый ПараметрыДиалогаПомещенияФайлов;
	ПараметрыДиалога.Фильтр = "Текстовый документ|*.csv";
	
	Результат = Ждать ПоместитьФайлНаСерверАсинх(,,, ПараметрыДиалога);
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.ПомещениеФайлаОтменено Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузкаНаСервере(Результат.Адрес);

КонецПроцедуры

&НаСервере
Процедура ЗагрузкаНаСервере(АдресВременногоХранилища)
	
	ДанныеФайла = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	ДанныеДляОбмена.Прочитать(ДанныеФайла.ОткрытьПотокДляЧтения(), КодировкаТекста.UTF8);
	
	КоличествоСтрок = ДанныеДляОбмена.КоличествоСтрок();
	
	РежимРаботы = "ПоискОбъекта";
	
	Для Сч = 1 По КоличествоСтрок Цикл
		
		Строка = ДанныеДляОбмена.ПолучитьСтроку(Сч);
		
		МассивДанных = СтрРазделить(Строка, ",");
		
		ЭлементТипНомера = Справочники.ТипыНомеров.СоздатьЭлемент();
		
		ЭлементТипНомера.Наименование = СокрЛП((МассивДанных[0]));
		ЭлементТипНомера.Количество = СокрЛП((МассивДанных[1]));
		ЭлементТипНомера.Цена = СокрЛП((МассивДанных[2]));
		ЭлементТипНомера.Описание = СокрЛП((МассивДанных[3]));
		
		ЭлементТипНомера.Записать();
		
		ЭлементПостояльцы = Справочники.Постояльцы.СоздатьЭлемент();
		
		ЭлементПостояльцы.Наименование = СокрЛП((МассивДанных[4]));
		ЭлементПостояльцы.Телефон = СокрЛП((МассивДанных[5]));
		ЭлементПостояльцы.АдресЭлектроннойПочты = СокрЛП((МассивДанных[6]));
		ЭлементПостояльцы.Пол = Перечисления.ПолФизическихЛиц[СокрЛП((МассивДанных[4]))];
		
	КонецЦикла;
	
КонецПроцедуры



&НаКлиенте
Процедура Выгрузка(Команда)
	
	Адрес = ВыгрузкаНаСервере();
	
	ПараметрыПолучения = Новый ПараметрыДиалогаПолученияФайлов;
	ПолучитьФайлССервераАсинх(Адрес, "exchange.txt", ПараметрыПолучения);
	СоздатьАрхивZIP();

КонецПроцедуры

Процедура СоздатьАрхивZIP()

	// Создадим объект записи ZIP-архива
	ЗаписьZIP = Новый ЗаписьZipФайла("C:\Учеба\База.zip",
					" ",
					" ",
					МетодСжатияZIP.Сжатие,
					УровеньСжатияZIP.Максимальный,
					МетодШифрованияZIP.Zip20);
	
	// Добавим необходимые файлы в архив
	ЗаписьZIP.Добавить("c:\Учеба\exchange.txt", РежимСохраненияПутейZIP.НеСохранятьПути);
		
	// Запишем архив на диск
	ЗаписьZIP.Записать();

КонецПроцедуры

&НаСервере
Функция ВыгрузкаНаСервере()
	
	ДанныеДляОбмена.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТипыНомеров.Ссылка,
		|	ТипыНомеров.Наименование,
		|	ТипыНомеров.Количество,
		|	ТипыНомеров.Цена,
		|	ТипыНомеров.Описание
		|ИЗ
		|	Справочник.ТипыНомеров КАК ТипыНомеров";
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДанныеДляОбмена.ДобавитьСтроку("Начало: ТипНомера");
		
		ДанныеДляОбмена.ДобавитьСтроку(Строка(Выборка.Ссылка.УникальныйИдентификатор()));
		ДанныеДляОбмена.ДобавитьСтроку(Выборка.Наименование);
		ДанныеДляОбмена.ДобавитьСтроку(XMLСтрока(Выборка.Количество));
		ДанныеДляОбмена.ДобавитьСтроку(XMLСтрока(Выборка.Цена));
		ДанныеДляОбмена.ДобавитьСтроку(СтрЗаменить(Выборка.Описание, Символы.ПС, "\n"));
		
		ДанныеДляОбмена.ДобавитьСтроку("Конец: ТипНомера");
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Бронирование.Ссылка,
		|	Бронирование.ДатаЗаезда,
		|	Бронирование.ДатаВыезда,
		|	Бронирование.ТипНомера
		|ИЗ
		|	Документ.Бронирование КАК Бронирование";
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДанныеДляОбмена.ДобавитьСтроку("Начало: Бронирование");
		
		ДанныеДляОбмена.ДобавитьСтроку(Строка(Выборка.Ссылка.УникальныйИдентификатор()));
		ДанныеДляОбмена.ДобавитьСтроку(ЗаписатьДатуJSON(Выборка.ДатаЗаезда, ФорматДатыJSON.ISO));
		ДанныеДляОбмена.ДобавитьСтроку(ЗаписатьДатуJSON(Выборка.ДатаВыезда, ФорматДатыJSON.ISO));
		ДанныеДляОбмена.ДобавитьСтроку(Строка(Выборка.ТипНомера.УникальныйИдентификатор()));
		
		ДанныеДляОбмена.ДобавитьСтроку("Конец: Бронирование");
		
	КонецЦикла;
	
	Поток = Новый ПотокВПамяти();
	
	ДанныеДляОбмена.Записать(Поток);
	
	ДанныеФайла = Поток.ЗакрытьИПолучитьДвоичныеДанные();
	
	Адрес = ПоместитьВоВременноеХранилище(ДанныеФайла);
	
	Возврат Адрес;
	
КонецФункции
