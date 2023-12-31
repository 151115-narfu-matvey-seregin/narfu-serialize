&НаКлиенте
Асинх Процедура Загрузка(Команда)
	
	ПараметрыДиалога = Новый ПараметрыДиалогаПомещенияФайлов;
	ПараметрыДиалога.Фильтр = "Текстовый документ|*.xlsx";
	
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
Процедура ЗагрузкаНаСервере(Адрес)
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
	ИмяВременногоФайлаxlsx = ПолучитьИмяВременногоФайла("xlsx"); // например был помещен XML
	ДвоичныеДанные.Записать(ИмяВременногоФайлаxlsx);                
	ДанныеДляОбмена.Прочитать(ИмяВременногоФайлаxlsx);
КонецПроцедуры  

&НаКлиенте
Процедура ЗагрузитьВБазу(Команда) 
ЗагрузитьВБазуСервера();	
КонецПроцедуры 

&НаСервере
Процедура ЗагрузитьВБазуСервера()
	ГлубХ=0; 
	ГлубУ=0; 
	Номер=1;
Если ДанныеДляОбмена.Область("R1C1").Текст = "Типы номеров" Тогда
			Если ДанныеДляОбмена.Область("R1C2").Текст = "Наименование" Тогда 
			Сообщить("Вертикальная ориентация");
			ПоОсиХ=0;
			ПоОсиУ=1; 
			ГлубХ=2;
			ИначеЕсли ДанныеДляОбмена.Область("R2C1").Текст = "Наименование" Тогда
			Сообщить("Горизонтальная ориентация");
			ПоОсиХ=1;
			ПоОсиУ=0;
			ГлубУ=2;
			Иначе
			Сообщить("Не удалось узнать ориентацию таблицы");
			Возврат;	
			КонецЕсли;
				
		Иначе
			Сообщить("Начало таблицы не обнаружено");
			Возврат;
		КонецЕсли;  
		Икс=1;
		Угрик=1;  
		Раздел=""; 
		Пункт="";
		Текст="";
		Сумма="";  
		Для Счетчик = 1 По 3 Цикл 
			Сумма="";
			Икс= 1+((Счетчик-1)*5*ПоОсиХ);
			Угрик= 1+((Счетчик-1)*5*ПоОсиУ);   
			Раздел =ДанныеДляОбмена.Область("R"+ Угрик + "C" + Икс ).Текст;
			Пункты= Новый Массив(5); 
			Для Счетчик1 = 1 По 5 Цикл
				Если ПоОсиХ=0 Тогда 
					Х=Счетчик1+((Счетчик-1)*5*ПоОсиУ);
			Пункты[Счетчик1-1]=ДанныеДляОбмена.Область("R"+ Х + "C" + 2).Текст;
		Иначе       
			У=Счетчик1+((Счетчик-1)*5*ПоОсиХ);
			 Пункты[Счетчик1-1]=ДанныеДляОбмена.Область("R"+ 2 + "C" + У).Текст;
			 КонецЕсли;
		КонецЦикла;     
		Кол_ВоДанныхВСтроке=0;
		Конец=1;    
		СчётХ=1;
		СчётУ=1;
		Пока Конец=1 Цикл
			Х=((Счетчик-1)*5*ПоОсиХ)+ГлубХ+СчётХ;
			У=((Счетчик-1)*5*ПоОсиУ)+ГлубУ+СчётУ;
			Если ДанныеДляОбмена.Область("R"+ У + "C" + Х).Текст = "" Тогда
				Если Кол_ВоДанныхВСтроке=0 Тогда
					Кол_ВоДанныхВСтроке=1;
					КонецЕсли;
				Кол_ВоДанныхВСтроке=Кол_ВоДанныхВСтроке*5;
				Конец=0;
			Иначе   
				СчётУ=СчётУ+ПоОсиХ;
				СчётХ=СчётХ+ПоОсиУ;
				Кол_ВоДанныхВСтроке=Кол_ВоДанныхВСтроке+1;
			КонецЕсли;
		КонецЦикла;	
		СтрокаУ=1+ГлубУ;
		СтрокаХ=1+ГлубХ;
		Поз=0;             
		Для Счетчик1 = 1 По Кол_ВоДанныхВСтроке Цикл
			Если Поз=0 Тогда
			КонецЕсли;
		    Пункт =Пункты[Поз];
			Х=СтрокаХ+((Счетчик-1)*5*ПоОсиХ);
			У=СтрокаУ+((Счетчик-1)*5*ПоОсиУ);
			Текст =ДанныеДляОбмена.Область("R"+ У + "C" + Х ).Текст; 
			Если ПоОсиХ=0 Тогда    
				Если СтрокаУ >= 5 Тогда
				 СтрокаУ=1;
				 СтрокаХ=СтрокаХ+1;
				 Поз=0;     			 Иначе  
				 Поз=Поз+1;
				 СтрокаУ=СтрокаУ+1;
			 КонецЕсли;
		 Иначе
			 Если СтрокаХ >= 5 Тогда
				 СтрокаХ=1;
				 СтрокаУ=СтрокаУ+1;
				 Поз=0;     
			 Иначе 
				 Поз=Поз+1;
				 СтрокаХ=СтрокаХ+1;
			 КонецЕсли;
			 ВыводТекста.ДобавитьСтроку(Раздел+" "+Пункт+" "+Текст);
			 Если Раздел="Типы номеров" Тогда 
				 Если Пункт = "Наименование" Тогда   
					 ЗагружаемыйОбъект =  Справочники.ТипыНомеров.СоздатьГруппу();
					 ЗагружаемыйОбъект.Наименование=Текст;
				 ИначеЕсли Пункт = "Идентификатор" Тогда
					 ЗагружаемыйОбъект.ПолучитьСсылкуНового();
				 ИначеЕсли Пункт = "Количество" Тогда
					 ЗагружаемыйОбъект.Количество=Текст;
				 ИначеЕсли Пункт = "Цена" Тогда 
					 ЗагружаемыйОбъект.Цена=Текст;
				 ИначеЕсли Пункт = "Описание" Тогда
					 ЗагружаемыйОбъект.Описание=Текст;
					 ЗагружаемыйОбъект.ОбменДанными.Загрузка = Истина;
			     ЗагружаемыйОбъект.Записать();
				 Иначе
					Сообщить("Поломка в Тип Номеров."); 
				 КонецЕсли;
				 
				 
			 ИначеЕсли Раздел="Постояльцы" Тогда
				 Если Пункт = "ФИО" Тогда   
					 ЗагружаемыйОбъект =  Справочники.Постояльцы.СоздатьГруппу();
					 ЗагружаемыйОбъект.Код=Номер;
					 Номер=Номер+1;
					 ЗагружаемыйОбъект.Наименование=Текст;
				 ИначеЕсли Пункт = "Телефон" Тогда
					 ЗагружаемыйОбъект.Телефон=Текст;
				 ИначеЕсли Пункт = "АдресЭлектроннойПочты" Тогда
					 ЗагружаемыйОбъект.АдресЭлектроннойПочты=Текст;
				 ИначеЕсли Пункт = "Пол" Тогда 
					 Если Текст= "Женский" Тогда 
						 ЗагружаемыйОбъект.Пол = Перечисления.ПолФизическихЛиц.Женский;
					 Иначе
						 ЗагружаемыйОбъект.Пол = Перечисления.ПолФизическихЛиц.Мужской;
					 КонецЕсли;
				 ИначеЕсли Пункт = "ДатаРождения" Тогда
					 ЗагружаемыйОбъект.ДатаРождения=Текст;
					 ЗагружаемыйОбъект.ОбменДанными.Загрузка = Истина;
			     ЗагружаемыйОбъект.Записать();
				 Иначе
					Сообщить("Поломка в Тип Номеров."); 
				 КонецЕсли;
			 ИначеЕсли Раздел="Бронирование" Тогда
				 Если Пункт = "ДатаЗаезда" Тогда   
					 ЗагружаемыйОбъект =  Документы.Бронирование.СоздатьДокумент();
					 ЗагружаемыйОбъект.ДатаЗаезда=Текст;
				 ИначеЕсли Пункт = "ДатаВыезда" Тогда
					 ЗагружаемыйОбъект.ДатаВыезда=Текст;
				 ИначеЕсли Пункт = "ТипНомера" Тогда
					 Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТипыНомеров.Наименование,
		|	ТипыНомеров.Ссылка
		|ИЗ
		|	Справочник.ТипыНомеров КАК ТипыНомеров"; 
	                 Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Название=Выборка.Наименование;
		Ссылаемся=Выборка.Ссылка;
		Если  Название = Текст Тогда
			Прервать;
			КонецЕсли;
		КонецЦикла;  
 	             ЗагружаемыйОбъект.ТипНомера=Ссылаемся;
			 ИначеЕсли Пункт = "ЗавтракВключен" Тогда 
				 ЗагружаемыйОбъект.Дата= ТекущаяДата();
			ИначеЕсли Пункт = "Постоялец" Тогда
				Запрос.Текст = 
		"ВЫБРАТЬ
		|	Постояльцы.Наименование, 
		|	Постояльцы.Ссылка
		|ИЗ
		|	Справочник.Постояльцы КАК Постояльцы"; 
	                 Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Название=Выборка.Наименование;
		Ссылаемся=Выборка.Ссылка;
		Если  Название = Текст Тогда
			Прервать;
			КонецЕсли;
		КонецЦикла;
				   ЗагружаемыйОбъект.Постояльцы.Добавить().Постоялей=Ссылаемся;
				   ЗагружаемыйОбъект.ОбменДанными.Загрузка = Истина;
				   ЗагружаемыйОбъект.Записать();
					 Иначе
					Сообщить("Поломка в Тип Номеров.");
				 КонецЕсли;	
			 КонецЕсли;
		 КонецЕсли;
	 КонецЦикла; 
 КонецЦикла; 
КонецПроцедуры 

