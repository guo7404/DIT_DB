--1) 기본 SQL(select, where, 그룹함수, group by, having, order by) - 기본 5개
--1. 각 태풍의 발생 날짜와 태풍 이름 조회
select tyname as 태풍이름, cdate as 발생일
from typhoon;

--2. 각 지역의 총 피해 금액과 지역 번호 조회
select regno as 지역번호, sum(prodmg) as 총피해금액
from impact
group by regno;

--3. 각 태풍의 발생 일수 조회
select tyno as 태풍번호, (edate - cdate) as 발생일수
from typhoon
where edate is not null;

--4. 특정 태풍의 피해자 수와 피해 금액을 조회 (예: tyno가 1인 태풍)
select tyno as 태풍번호, sum(misperson + inperson + evaperson) as 총피해자수, sum(prodmg) as 총피해금액
from impact
where tyno = 1
group by tyno;

--5. 각 태풍 등급별 태풍 개수 조회
select rno as 태풍등급번호, 
       count(*) as 태풍개수
from typhoon
group by rno
order by rno;

--2) JOIN – 기본 2개
--1. 태풍으로 인한 피해자 수 조회
SELECT t.tyname AS 태풍이름, i.misperson as "사망,실종자", i.inperson 부상자, i.evaperson 대피자
FROM Typhoon t
JOIN Impact i ON t.tyno = i.tyno;

--2. 지역별 태풍 발생 수 조회
SELECT r.regname AS 지역명, 
       COUNT(t.tyno) AS 태풍발생수
FROM Region r
JOIN impact t ON r.regno = t.regno
GROUP BY r.regname;

--3. 각 태풍 등급별 태풍 개수 조회
SELECT trs.rno AS 태풍등급번호, 
       trs.rname AS 태풍등급명, 
       COUNT(*) AS 태풍개수
FROM Typhoon t
INNER JOIN Typhoon_Rating_System trs ON t.rno = trs.rno
GROUP BY trs.rno, trs.rname
ORDER BY trs.rno;

--4. 각 태풍의 피해자 수 및 지역 정보 조회
SELECT t.tyname AS 태풍이름, 
       LISTAGG(r.regname, ', ') AS 지역명,
       SUM(i.misperson + i.inperson + i.evaperson) AS 총피해자수
FROM Typhoon t
INNER JOIN Impact i ON t.tyno = i.tyno
LEFT OUTER JOIN Region r ON i.regno = r.regno
GROUP BY t.tyname
ORDER BY t.tyname;

--3) Sub Query – 기본 3개
--1. 특정 태풍의 피해자 수가 가장 많은 지역 조회
SELECT r.regname AS 지역명
FROM Region r
WHERE r.regno IN (
    SELECT i.regno
    FROM Impact i
    WHERE i.tyno = (SELECT t.tyno
                    FROM Typhoon t
                    WHERE t.tyname = '링링')-- 여기서 '특정 태풍 이름'을 실제 태풍 이름으로 변경
);

--2. 피해금액이 가장 높은 태풍의 이름 조회
SELECT t.tyname AS 태풍이름, r.regname AS 지역명
FROM Typhoon t
JOIN Impact i ON t.tyno = i.tyno
JOIN Region r ON i.regno = r.regno
WHERE i.prodmg IN (SELECT MAX(prodmg)
                   FROM Impact);

--3. 각 태풍의 피해자 수가 전체 평균보다 많은 태풍 조회
SELECT t.tyname AS 태풍이름
FROM Typhoon t
WHERE 
    (SELECT SUM(i.misperson + i.inperson + i.evaperson) / COUNT(*)
     FROM Impact i
     WHERE i.tyno = t.tyno) > 
    (SELECT AVG(misperson + inperson + evaperson) 
     FROM Impact);