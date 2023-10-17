create table ksiegowosc.pracownicy(
	id_pracownika SERIAL primary key,
	imie varchar(50),
	nazwisko varchar(100),
	adres varchar(200),
	telefon varchar(12)
	);
	
create table ksiegowosc.godziny(
	id_godziny SERIAL primary key,
	data DATE,
	liczba_godzin INTEGER,
	id_pracownika INTEGER,
	foreign key (id_pracownika) references ksiegowosc.pracownicy(id_pracownika));

create table ksiegowosc.pensja(
	id_pensja SERIAL primary key,
	stanowisko VARCHAR(100),
	kwota DECIMAL(10, 2));


create table ksiegowosc.premia(
	id_premii SERIAL primary key,
	rodzaj VARCHAR(50),
	kwota DECIMAL(10, 2));

create table ksiegowosc.wynagrodzenie(
	id_wynagrodzenia SERIAL primary key,
	data DATE,
	id_pracownika INTEGER,
	id_godziny INTEGER,
	id_pensja INTEGER,
	id_premii INTEGER,
	foreign key (id_pracownika) references ksiegowosc.pracownicy(id_pracownika),
	foreign key (id_godziny) references ksiegowosc.godziny(id_godziny),
        foreign key (id_pensja) references ksiegowosc.pensja(id_pensja),
        foreign key (id_premii) references ksiegowosc.premia(id_premii));
       

-- zad 4       
-- Tabela pracownicy
INSERT INTO ksiegowosc.pracownicy (imie, nazwisko, adres, telefon)
VALUES
    ('Jan', 'Kowalski', 'ul. Przykładowa 1', '123-456-789'),
    ('Anna', 'Nowak', 'ul. Inna 2', '987-654-321'),
    ('Piotr', 'Nowicki', 'ul. Testowa 3', '555-111-222'),
    ('Maria', 'Dąbrowska', 'ul. Prosta 4', '333-444-555'),
    ('Tomasz', 'Zieliński', 'ul. Różana 5', '666-777-888'),
    ('Agnieszka', 'Kowalczyk', 'ul. Leśna 6', '999-000-111'),
    ('Krzysztof', 'Szymański', 'ul. Kwiatowa 7', '111-222-333'),
    ('Ewa', 'Wojcik', 'ul. Słoneczna 8', '444-555-666'),
    ('Marek', 'Kaczmarek', 'ul. Ogrodowa 9', '777-888-999'),
    ('Karolina', 'Pawlak', 'ul. Polna 10', '111-222-333');
   
-- Tabela godziny
INSERT INTO ksiegowosc.godziny (data, liczba_godzin, id_pracownika)
VALUES
    ('2023-01-01', 40, 1),
    ('2023-01-02', 35, 2),
    ('2023-01-03', 38, 3),
    ('2023-01-04', 42, 4),
    ('2023-01-05', 37, 5),
    ('2023-01-06', 40, 6),
    ('2023-01-07', 39, 7),
    ('2023-01-08', 36, 8),
    ('2023-01-09', 41, 9),
    ('2023-01-10', 37, 10);
   

   
-- Tabela pensja
INSERT INTO ksiegowosc.pensja (stanowisko, kwota)
VALUES
    ('Księgowy', 4500.00),
    ('Asystent księgowego', 3500.00),
    ('Kierownik finansów', 5500.00),
    ('Specjalista ds. podatków', 4000.00),
    ('Analityk finansowy', 4800.00),
    ('Kadrowy', 3600.00),
    ('Pracownik obsługi księgowej', 3400.00),
    ('Audytor', 5200.00),
    ('Doradca podatkowy', 4600.00),
    ('Finansista', 4300.00);
       
   
-- Tabela premia
INSERT INTO ksiegowosc.premia (rodzaj, kwota)
VALUES
    ('Premia roczna', 1000.00),
    ('Premia za wydajność', 500.00),
    ('Premia za staż', 800.00),
    ('Premia za osiągnięcia', 1200.00),
    ('Premia za wyniki firmy', 1500.00),
    ('Premia za innowacje', 600.00),
    ('Premia za dodatkowe szkolenia', 700.00),
    ('Premia za dodatkową pracę', 900.00),
    ('Premia za efektywność', 1100.00),
    ('Premia za zaangażowanie', 750.00);
       
-- Tabela wynagrodzenie
INSERT INTO ksiegowosc.wynagrodzenie (data, id_pracownika, id_godziny, id_pensja, id_premii)
VALUES
    ('2023-01-01', 1, 1, 1, 1),
    ('2023-01-02', 2, 2, 2, 2),
    ('2023-01-03', 3, 3, 3, 3),
    ('2023-01-04', 4, 4, 4, 4),
    ('2023-01-05', 5, 5, 5, 5),
    ('2023-01-06', 6, 6, 6, 6),
    ('2023-01-07', 7, 7, 7, 7),
    ('2023-01-08', 8, 8, 8, 8),
    ('2023-01-09', 9, 9, 9, 9),
    ('2023-01-10', 10, 10, 10, 10);
	
-- zad 5a
 select id_pracownika, nazwisko from ksiegowosc.pracownicy
 
-- 5b
 select w.id_pracownika from ksiegowosc.wynagrodzenie w 
 left join ksiegowosc.pensja p on p.id_pensja = w.id_pensja 
 where p.kwota > 4000
 
 -- 5c
 select prac.id_pracownika, pen.kwota, pre.kwota from ksiegowosc.pracownicy as prac
    inner join ksiegowosc.wynagrodzenie as wyn on wyn.id_pracownika = prac.id_pracownika
    inner join ksiegowosc.pensja as pen on wyn.id_pensja = pen.id_pensja
    inner join ksiegowosc.premia as pre on wyn.id_premii = pre.id_premii
    where pen.kwota > 2000 and pre.kwota is null;
    
-- 5d
select imie from ksiegowosc.pracownicy
    where imie like 'J%'   
   
-- 5e
select imie, nazwisko from ksiegowosc.pracownicy
    where nazwisko like '%n%' and imie like '%a';
   
-- 5f
select prac.imie, prac.nazwisko, god.liczba_godzin,
    case when god.liczba_godzin > 160 then god.liczba_godzin - 160
    else 0 end as liczba_nadgodzin
    from ksiegowosc.pracownicy prac
    inner join ksiegowosc.wynagrodzenie wyn on wyn.id_pracownika = prac.id_pracownika
    inner join ksiegowosc.pensja pen on wyn.id_pensja = pen.id_pensja
    inner join ksiegowosc.godziny god on wyn.id_godziny = god.id_godziny   
    
-- 5g
select prac.imie, prac.nazwisko, pen.kwota from ksiegowosc.pracownicy prac
    inner join ksiegowosc.wynagrodzenie wyn on wyn.id_pracownika = prac.id_pracownika
    inner join ksiegowosc.pensja pen on wyn.id_pensja = pen.id_pensja
    where pen.kwota between 1500 and 4000; 
   
   
-- 5h
select prac.imie, prac.nazwisko from ksiegowosc.pracownicy prac
    inner join ksiegowosc.wynagrodzenie wyn ON wyn.id_pracownika = prac.id_pracownika
    inner join ksiegowosc.pensja pen ON wyn.id_pensja = pen.id_pensja
    inner join ksiegowosc.godziny god ON wyn.id_godziny = god.id_godziny
    left join ksiegowosc.premia pre ON wyn.id_premii = pre.id_premii
    where god.liczba_godzin > 160 and pre.id_premii is null;   
   
-- 5i
select prac.imie, prac.nazwisko, pen.kwota from ksiegowosc.pracownicy  prac
    inner join ksiegowosc.wynagrodzenie  wyn ON wyn.id_pracownika = prac.id_pracownika
    inner join ksiegowosc.pensja  pen ON wyn.id_pensja = pen.id_pensja
    order by pen.kwota
   
-- 5j
select prac.imie, prac.nazwisko, pen.kwota from ksiegowosc.pracownicy  prac
    inner join ksiegowosc.wynagrodzenie  wyn ON wyn.id_pracownika = prac.id_pracownika
    inner join ksiegowosc.pensja  pen ON wyn.id_pensja = pen.id_pensja
    order by pen.kwota desc
    
-- 5k
select pen.stanowisko, COUNT(pen.stanowisko) from ksiegowosc.pracownicy  prac
    inner join ksiegowosc.wynagrodzenie  wyn ON wyn.id_pracownika = prac.id_pracownika
    inner join ksiegowosc.pensja  pen ON wyn.id_pensja = pen.id_pensja
    group by pen.stanowisko;    
   
-- 5l
select pen.stanowisko, AVG(pen.kwota), MIN(pen.kwota), MAX(pen.kwota) from ksiegowosc.pracownicy  prac
    inner join ksiegowosc.wynagrodzenie  wyn ON wyn.id_pracownika = prac.id_pracownika
    inner join ksiegowosc.pensja  pen ON wyn.id_pensja = pen.id_pensja
    where pen.stanowisko = 'Finansista'
	group by pen.stanowisko;

-- 5m
select SUM(pen.kwota) from ksiegowosc.pracownicy  prac
    inner join ksiegowosc.wynagrodzenie  wyn ON wyn.id_pracownika = prac.id_pracownika
    inner join ksiegowosc.pensja  pen ON wyn.id_pensja = pen.id_pensja
    
-- 5n
select pen.stanowisko, SUM(pen.kwota) from ksiegowosc.pracownicy  prac
    inner join ksiegowosc.wynagrodzenie  wyn ON wyn.id_pracownika = prac.id_pracownika
    inner join ksiegowosc.pensja  pen ON wyn.id_pensja = pen.id_pensja
    group by pen.stanowisko    

-- 5o
select pen.stanowisko, COUNT(pre.id_premii)  liczba_premii
    from ksiegowosc.pensja  pen
    inner join ksiegowosc.wynagrodzenie  wyn ON pen.id_pensja = wyn.id_pensja
    left join ksiegowosc.premia  pre ON wyn.id_premii = pre.id_premii
    group by pen.stanowisko;
   
-- 5p
--delete from ksiegowosc.pracownicy   
--    where id_pracownika in (
--      select prac.id_pracownika
--      from ksiegowosc.pracownicy  prac
--      inner join ksiegowosc.wynagrodzenie  wyn on wyn.id_pracownika = prac.id_pracownika
--      inner join ksiegowosc.pensja  pen on wyn.id_pensja = pen.id_pensja
--      where pen.kwota < 4200);
   