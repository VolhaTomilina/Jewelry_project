﻿Процедура РасчетНачисления(ЗаписиРегистра,ВидРасчета,СписокСотрудников) Экспорт
	Регистратор = ЗаписиРегистра.Отбор.Регистратор.Значение;
	Если ВидРасчета = ПланыВидовРасчета.ОсновныеНачисления.Оклад Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	НачисленияДанныеГрафика.ЗначениеПериодДействия КАК Норма,
		               |	НачисленияДанныеГрафика.ЗначениеФактическийПериодДействия КАК Факт,
		               |	НачисленияДанныеГрафика.НомерСтроки КАК НомерСтроки
		               |ИЗ
		               |	РегистрРасчета.Начисления.ДанныеГрафика(
		               |			Регистратор = &Регистратор
		               |				И ВидРасчета = &ВидРасчета
		               |				И Сотрудник В (&СпСотрудники)) КАК НачисленияДанныеГрафика";
		Запрос.УстановитьПараметр("Регистратор",Регистратор);
		Запрос.УстановитьПараметр("ВидРасчета",ВидРасчета);
		Запрос.УстановитьПараметр("СпСотрудники",СписокСотрудников);
		
		ВыборкаРезультата = Запрос.Выполнить().Выбрать();
		
		Для каждого Запись Из ЗаписиРегистра Цикл
			Номер = Новый Структура("НомерСтроки");
			Номер.НомерСтроки = Запись.НомерСтроки;
			ВыборкаРезультата.Сбросить();
			
			Если ВыборкаРезультата.НайтиСледующий(Номер) Тогда
				//расчет оклада
				Если ВыборкаРезультата.Норма = 0 Тогда
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = "Для расчета ОКЛАДА не задан график работы";
					Сообщение.Сообщить();
				Иначе
					Запись.Результат = (Запись.ИсходныеДанные / ВыборкаРезультата.Норма) * ВыборкаРезультата.Факт;
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = "Оклад для - " + Запись.Сотрудник + " рассчитан";
					Сообщение.Сообщить();
				КонецЕсли
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ВидРасчета = ПланыВидовРасчета.ОсновныеНачисления.Премия Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	НачисленияБазаНачисления.РезультатБаза КАК РезультатБаза,
		               |	НачисленияБазаНачисления.НомерСтроки КАК НомерСтроки
		               |ИЗ
		               |	РегистрРасчета.Начисления.БазаНачисления(
		               |			&ИзмеренияОсновного,
		               |			&ИзмеренияБазового,
		               |			,
		               |			Регистратор = &Регистратор
		               |				И ВидРасчета = &ВидРасчета
		               |				И Сотрудник В (&СпСотрудников)) КАК НачисленияБазаНачисления";
		Измерения = Новый Массив(1);
		Измерения[0] = "Сотрудник";
		Запрос.УстановитьПараметр("ИзмеренияОсновного", Измерения);
		Запрос.УстановитьПараметр("ИзмеренияБазового", Измерения);
		Запрос.УстановитьПараметр("Регистратор",Регистратор);
		Запрос.УстановитьПараметр("ВидРасчета",ВидРасчета);
		Запрос.УстановитьПараметр("СпСотрудников",СписокСотрудников);
		
		ВыборкаРезультата = Запрос.Выполнить().Выбрать();
		
		Для каждого Запись Из ЗаписиРегистра Цикл
			НомерСтруктура = Новый Структура("НомерСтроки");
			НомерСтруктура.НомерСтроки = Запись.НомерСтроки;
			ВыборкаРезультата.Сбросить();
			
			Если ВыборкаРезультата.НайтиСледующий(НомерСтруктура) Тогда
				Запись.Результат = ВыборкаРезультата.РезультатБаза * (30/100);
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Премия для " + Запись.Сотрудник + " расчитана";
				Сообщение.Сообщить();
			КонецЕсли;
		КонецЦикла;

	КонецЕсли;
КонецПроцедуры
