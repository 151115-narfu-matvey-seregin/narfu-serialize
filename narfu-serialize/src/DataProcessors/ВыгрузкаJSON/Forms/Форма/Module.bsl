&НаКлиенте
Процедура ЧтоВыгружаем(Команда)
Вывод();
КонецПроцедуры  

&НаСервере
Процедура Вывод()
ТестовыйВывод.Очистить();
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
		ТестовыйВывод.ДобавитьСтроку(Выборка.Наименование);
		ТестовыйВывод.ДобавитьСтроку(Строка(Выборка.Ссылка.УникальныйИдентификатор()));
		ТестовыйВывод.ДобавитьСтроку(XMLСтрока(Выборка.Цена));
		ТестовыйВывод.ДобавитьСтроку(XMLСтрока(Выборка.Количество));
		ТестовыйВывод.ДобавитьСтроку(Выборка.Описание);
		ТестовыйВывод.ДобавитьСтроку("&*&");  
	КонецЦикла; 
	Строк= ТестовыйВывод.КоличествоСтрок();
	ТестовыйВывод.УдалитьСтроку(Строк);
	ТестовыйВывод.ДобавитьСтроку("КонецТипаН.");
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Постояльцы.Наименование,
		|	Постояльцы.Телефон,
		|	Постояльцы.АдресЭлектроннойПочты, 
		|   Постояльцы.Пол,
		|   Постояльцы.ДатаРождения
		|ИЗ
		|	Справочник.Постояльцы КАК Постояльцы";
		
	Выборка = Запрос.Выполнить().Выбрать();
	Порядковыйномер=1;
	Пока Выборка.Следующий() Цикл
		ТестовыйВывод.ДобавитьСтроку(Выборка.Наименование);
		ТестовыйВывод.ДобавитьСтроку(Выборка.Телефон);
		ТестовыйВывод.ДобавитьСтроку(Выборка.АдресЭлектроннойПочты);
		ТестовыйВывод.ДобавитьСтроку(Выборка.Пол);
		ТестовыйВывод.ДобавитьСтроку(XMLСтрока(Выборка.ДатаРождения));
		ТестовыйВывод.ДобавитьСтроку("&*&");
	КонецЦикла;
	Строк= ТестовыйВывод.КоличествоСтрок();
	ТестовыйВывод.УдалитьСтроку(Строк);
	ТестовыйВывод.ДобавитьСтроку("КонецПост.");
Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ 
		|	Бронирование.ДатаЗаезда, 
		|   Бронирование.ДатаВыезда,
		|   Бронирование.ТипНомера,
		|   Бронирование.Постояльцы
		|ИЗ
		|	Документ.Бронирование КАК Бронирование";
		
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ТестовыйВывод.ДобавитьСтроку(ЗаписатьДатуJSON(Выборка.ДатаЗаезда, ФорматДатыJSON.ISO));
		ТестовыйВывод.ДобавитьСтроку(ЗаписатьДатуJSON(Выборка.ДатаВыезда, ФорматДатыJSON.ISO));
		ТестовыйВывод.ДобавитьСтроку("Завтрак включен?");	
		ТестовыйВывод.ДобавитьСтроку(Выборка.ТипНомера);                                 
		//	     
		Запрос1 = Новый Запрос;
	Запрос1.Текст = 
		"ВЫБРАТЬ    
		|	Постояльцы.НомерСтроки,
		|	Постояльцы.Постоялей,
		|	Постояльцы.Ссылка.Номер,
		|	Постояльцы.Постоялей.Код
		|ИЗ
		|	Документ.Бронирование.Постояльцы КАК Постояльцы";
	Выборка1 = Запрос1.Выполнить().Выбрать();
	Пока Выборка1.Следующий() Цикл 
	Имя=Выборка1.Постоялей; 
	Порядок= Число(Выборка1.Постоялей.Код);
	Если Порядок = Порядковыйномер Тогда
		Строка=Строка(Имя)+"("+Строка(Выборка1.Постоялей.Код)+")";
		ТестовыйВывод.ДобавитьСтроку(Строка);
		КонецЕсли;
	КонецЦикла;	
	
	Порядковыйномер=Порядковыйномер+1;
		//
		ТестовыйВывод.ДобавитьСтроку("&*&");
	КонецЦикла; 
	Строк= ТестовыйВывод.КоличествоСтрок();
	ТестовыйВывод.УдалитьСтроку(Строк);
	ТестовыйВывод.ДобавитьСтроку("КонецБрони.");
	
КонецПроцедуры

&НаКлиенте
Процедура ТестовыйВидJSON(Команда)
Форматирование();	
КонецПроцедуры 
	
&НаСервере
Процедура Форматирование()
	Если ТестовыйВывод.ПолучитьТекст()="" Тогда
		Сообщить("Нечего форматировать, назжмите ""Тест"".");
		Возврат;
	КонецЕсли;
	Строк= ТестовыйВывод.КоличествоСтрок();
	Пункт = 0;
	Текст= "{""1. Типы номеров"":[{";
	Проверка=0;
	Запятая= 0;  
	Запятая = 0;
	Для Номер=1 По Строк Цикл 
		Если ТестовыйВывод.ПолучитьСтроку(Номер)="КонецТипаН." И Проверка =0 Тогда   
			Номер=Номер+1; 
			Текст= Текст+ "}],""2. Постояльцы"":[{";
			Проверка =1;
		ИначеЕсли ТестовыйВывод.ПолучитьСтроку(Номер)="КонецПост." И Проверка =1  Тогда  
			Номер=Номер+1;
			Текст= Текст+ "}],""3. Бронирования"":[{";
			Проверка =2;
		ИначеЕсли ТестовыйВывод.ПолучитьСтроку(Номер)="КонецБрони." И Проверка =2  Тогда  
			Номер=Номер+1;
			Текст= Текст+ "}]}";
			Проверка =3; 
			Прервать;
		ИначеЕсли  ТестовыйВывод.ПолучитьСтроку(Номер)="&*&" Тогда
			Текст=Текст+"},{";
			Пункт=Пункт-5;
			Запятая = 1;
		ИначеЕсли Номер > 1 и Запятая = 0 Тогда
		Текст= Текст+ ",";
	Иначе 
		Запятая = 0;
	КонецЕсли; 
	Если НЕ ТестовыйВывод.ПолучитьСтроку(Номер)= "&*&" Тогда
	Если Пункт = 0  Тогда 
			Текст= Текст+ """Название"":" + """"+ ТестовыйВывод.ПолучитьСтроку(Номер) +"""";
			Пункт = Пункт+1 ;
		ИначеЕсли Пункт =1 Тогда
			Текст= Текст+ """Идентификатор"":" + """"+ ТестовыйВывод.ПолучитьСтроку(Номер) +"""";
			Пункт = Пункт+1 ;
		ИначеЕсли Пункт =2 Тогда                                                        
			Текст= Текст+ """Цены"":" + """"+ ТестовыйВывод.ПолучитьСтроку(Номер) +"""";
			Пункт = Пункт+1 ;
		ИначеЕсли Пункт =3 Тогда                                                        
			Текст= Текст+ """Количество"":" + """"+ ТестовыйВывод.ПолучитьСтроку(Номер) +"""";
			Пункт = Пункт+1 ;
		ИначеЕсли Пункт =4 Тогда                                                        
			Текст= Текст+ """Описание"":" + """"+ ТестовыйВывод.ПолучитьСтроку(Номер) +"""";
			Пункт = Пункт+1 ;
		ИначеЕсли Пункт =5 Тогда  
			Текст= Текст+ """ФИО"":" + """"+ ТестовыйВывод.ПолучитьСтроку(Номер) +"""";
			Пункт = Пункт+1 ;
		ИначеЕсли Пункт =6 Тогда
			Текст= Текст+ """Телефон"":" + """"+ ТестовыйВывод.ПолучитьСтроку(Номер) +"""";
			Пункт = Пункт+1 ;
		ИначеЕсли Пункт =7 Тогда
			Текст= Текст+ """Адрес электронной почты"":" + """"+ ТестовыйВывод.ПолучитьСтроку(Номер) +"""";
			Пункт = Пункт+1 ;
		ИначеЕсли Пункт =8 Тогда 
			Текст= Текст+ """Пол"":" + """"+ ТестовыйВывод.ПолучитьСтроку(Номер) +""""; 
			Пункт = Пункт+1 ;
		ИначеЕсли Пункт =9 Тогда 
			Текст= Текст+ """Дата рождения"":" + """"+ ТестовыйВывод.ПолучитьСтроку(Номер) +"""";
			Пункт = Пункт+1 ;
		ИначеЕсли Пункт =10 Тогда 	
			Текст= Текст+ """Дата заезда"":" + """"+ ТестовыйВывод.ПолучитьСтроку(Номер) +"""";
			Пункт = Пункт+1 ;
		ИначеЕсли Пункт =11 Тогда 
			Текст= Текст+ """Дата выезда"":" + """"+ ТестовыйВывод.ПолучитьСтроку(Номер) +"""";
			Пункт = Пункт+1 ;
		ИначеЕсли Пункт =12 Тогда    
			Текст= Текст+ """Завтрак включен"":" + """"+ ТестовыйВывод.ПолучитьСтроку(Номер) +"""";
			Пункт = Пункт+1 ;
		ИначеЕсли Пункт =13 Тогда 
			Текст= Текст+ """Тип номера"":" + """"+ ТестовыйВывод.ПолучитьСтроку(Номер) +"""";
			Пункт = Пункт+1 ;
		ИначеЕсли Пункт =14 Тогда         
			Номер1=Номер+1;
			Если ТестовыйВывод.ПолучитьСтроку(Номер1)= "&*&" Тогда 
			Текст= Текст+ """Постояльцы (список)"":" + """"+ ТестовыйВывод.ПолучитьСтроку(Номер) +"""";
			Пункт = Пункт+1 ;
			Запятая = 1;
			Иначе
			Текст= Текст+ """Постояльцы (список)"":" + """"+ ТестовыйВывод.ПолучитьСтроку(Номер) +"""";
			КОнецЕсли;
		Иначе   
		КонецЕсли;
		КонецЕсли;
КонецЦикла;
Форматирование.ДобавитьСтроку(Текст);
КонецПроцедуры 


&НаКлиенте
Процедура ВыгрузкаJSON(Команда)
		
	Адрес = ВыгрузкаНаСервере();
	
	ПараметрыПолучения = Новый ПараметрыДиалогаПолученияФайлов;
	ПолучитьФайлССервераАсинх(Адрес, "Chtoto.json", ПараметрыПолучения);

КонецПроцедуры

&НаСервере
Функция ВыгрузкаНаСервере()   
	Поток = Новый ПотокВПамяти();
	Форматирование.Записать(Поток);
	ДанныеФайла = Поток.ЗакрытьИПолучитьДвоичныеДанные();
	ИмяВременногоФайлаxlsx = ПолучитьИмяВременногоФайла("json");
	ДанныеФайла.Записать(ИмяВременногоФайлаxlsx);
	Адрес = ПоместитьВоВременноеХранилище(ДанныеФайла);
	Форматирование.Очистить();
	ТестовыйВывод.Очистить();
	Возврат Адрес;
	
КонецФункции