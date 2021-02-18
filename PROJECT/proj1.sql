-- comp9311 19T3 Project 1
--
-- MyMyUNSW Solutions


-- Q1:
create or replace view Q1
as
select distinct rooms.unswid,rooms.longname
from facilities,rooms,room_facilities 
where facilities.description = 'Air-conditioned' 
AND room_facilities.room = rooms.id  
AND room_facilities.facility = facilities.id;

--... SQL statements, possibly using other views/functions defined by you ...
;

-- Q2:
create or replace view Q2_1 
as
select distinct people.id,course 
from people,course_enrolments
where people.name = 'Hemma Margareta'
AND people.id = course_enrolments.student;


create or replace view Q2(unswid,name)
as
select people.unswid,people.name
from course_staff,people,Q2_1
where people.id = course_staff.staff
AND course_staff.course = Q2_1.course;
--... SQL statements, possibly using other views/functions defined by you ...
;

-- Q3:
create or replace view Q3_1
as
select distinct people.id,people.name,semester
from subjects, people, courses,course_enrolments
where subjects.code = ‘COMP9311’
AND courses.id = course_enrolments.course
AND courses.subject = subjects.id
AND course_enrolments.student = people.id
AND courses.semester = semesters.id
AND course_enrolments.mark >=85;

create or replace view Q3_2
as
select distinct people.id,people.name,semester
from subjects, people, courses,course_enrolments
where subjects.code = ‘COMP9024’
AND courses.id = course_enrolments.course
AND courses.subject = subjects.id
AND course_enrolments.student = people.id
AND courses.semester = semesters.id
AND course_enrolments.mark >=85;

create or replace view Q3_3
as
select Q3_2.id,Q3_2.name,Q3_2.semester
from Q3_1,Q3_2
where Q3_1.semester = Q3_2.semester
AND Q3_1.id = Q3_2.id;

create or replace view Q3(unswid, name)
as 
select people.unswid,people.name
from Q3_3,people,students
where people.id = q3_3.id
AND people.name = Q3_3.name
AND students.stype = 'intl';
--... SQL statements, possibly using other views/functions defined by you ...
;

-- Q4:
create or replace view Q4_1
as
select distinct student,count(course_enrolments.grade)
from course_enrolments
where course_enrolments.grade = 'HD'
group by student;

create or replace view Q4_2
as
select distinct student,count(course_enrolments.mark)
from course_enrolments
group by student;

create or replace view Q4_3
as
select distinct Q4_2.student,Q4_2.count
from Q4_2
where Q4_2.count >=1;

create or replace view Q4_4
as
select sum(Q4_1.count)
from Q4_1;

create or replace view Q4_5
as
select count(Q4_3.count)
from Q4_3;

create or replace view Q4_6
as
select Q4_4.sum/Q4_5.count as AVG
from Q4_4,Q4_5;

create or replace view Q4(num_student)
as
select distinct count(Q4_1.count)
from Q4_1,Q4_6
where Q4_1.count > Q4_6.AVG;

--... SQL statements, possibly using other views/functions defined by you ...
;

--Q5:
create or replace view Q5_1
as
select course,count(course_enrolments.course)
from course_enrolments
where course_enrolments.mark is not null
group by course
having count(course_enrolments.mark)>=20;

create or replace view Q5_2
as
select distinct subjects.name as subjects_name,subjects.code,
semesters.name as semesters_name,max(mark)
from subjec,semesters,course_enrolments,Q5_1
where courses.subject = subjects.id
AND courses.semester = semesters.id
AND courses.id = course_enrolments.course
AND courses.id = Q5_1.course
group by subjects.name,subjects.code,semesters.name;

create or replace view Q5_3
as
select Q5_2.semesters_name,min(max)
from Q5_2
group by Q5_2.semesters_name;

create or replace view Q5(code, name, semester)
as
select Q5_2.code as code,Q5_2.subjects_name as name,
Q5_2.semesters_name as semester
from Q5_2,Q5_3
where Q5_3.semesters_name = Q5_2.semesters_name
AND Q5_3.min = Q5_2.max;
--... SQL statements, possibly using other views/functions defined by you ...
;

-- Q6:
create or replace view q6_1 
as
select distinct people.unswid,people.name 
from people,semesters,streams,students,
stream_enrolments,program_enrolments
where semesters.year = '2010'
AND semesters.term = 'S1'    
AND streams.name = 'Management'
AND students.stype = 'local'  
AND semesters.id = program_enrolments.semester
AND students.id = program_enrolments.student  
AND streams.id = stream_enrolments.stream    
AND stream_enrolments.partof = program_enrolments.id
AND students.id = people.id;

create or replace view Q6_2
as
select distinct people.unswid,people.name
from people,orgunits,subjects,courses,course_enrolments
where orgunits.name = 'Faculty of Engineering'
AND course_enrolments.student = people.id
AND subjects.id = courses.subject
AND orgunits.id = subjects.offeredby
AND courses.id = course_enrolments.course;

create or replace view Q6_3
as
select Q6_1.unswid    
from Q6_1
except
select Q6_2.unswid
from Q6_2;

create or replace view Q6(num)
as
select count(Q6_3.unswid)
from Q6_3;

--... SQL statements, possibly using other views/functions defined by you ...
;

-- Q7:
create or replace view Q7(year, term, average_mark)
as select distinct semesters.year,semesters.term, 
AVG(course_enrolments.mark)::numeric(4,2) as average_mark      
from semesters,subjects,courses,course_enrolments
where subjects.name = 'Database Systems'
AND course_enrolments.mark is not null
AND course_enrolments.course = courses.id 
AND courses.semester = semesters.id
AND subjects.id = courses.subject
group by semesters.year,semesters.term
order by semesters.year;

--... SQL statements, possibly using other views/functions defined by you ...
;

-- Q8: 
create or replace view Q8_1
as
select subjects.code,semesters.year,semesters.term  
from subjects,semesters,courses
where subjects.code like 'COMP93%'
AND subjects.id = courses.subject
AND semesters.id = courses.semester  
group by subjects.code,semesters.year,semesters.term;

create or replace view Q8_2
as
select  semesters.year,semesters.term  
from semesters  
where semesters.term like 'S%'  
AND semesters.year >='2004'
AND semesters.year <='2013';  

create or replace view Q8_3     
as
select distinct a.id from Q8_1 a 
where not exists(
    select Q8_2.year,Q8_2.term from Q8_2  
    where not exists (
        select *   
        from Q8_1 b
        where b.id = a.id 
        AND b.year = Q8_2.year  
        AND b.term = Q8_2.term)
        );

create or replace view Q8_4 
as    
select course_enrolments.student,subjects.code    
from courses,subjects,course_enrolments,Q8_3          
where course_enrolments.mark < 50       
AND course_enrolments.mark is not null 
AND subjects.code = Q8_3.id   
AND course_enrolments.course = courses.id   
AND courses.subject = subjects.id; 

create or replace view Q8_5
as
select distinct c.id from Q8_4 c
where not exists (
    select Q8_3.id from Q8_3
    where not exists(
        select * from Q8_4 d where d.id = c.id
        AND d.code = Q8_3.id)
        );

create or replace view Q8_6   
as
select distinct people.unswid,people.name
from people,Q8_5               
where Q8_5.id = people.id;

create or replace view Q8(zid, name)
as
select distinct 'z'||Q8_6.unswid as zid,Q8_6.name      
from Q8_6;

--... SQL statements, possibly using other views/functions defined by you ...
;

-- Q9:
create or replace view Q9_1
as
select distinct people.unswid,people.name
from people,programs,students,program_degrees,program_enrolments 
where program_degrees.abbrev = 'BSc'                   
AND program_degrees.program = programs.id 
AND program_enrolments.program = programs.id
AND program_enrolments.student = students.id
AND students.id = people.id;

create or replace view Q9_2
as
select distinct Q9_1.unswid,Q9_1.name
from Q9_1,people,courses,semesters,course_enrolments
where semesters.year = '2010'
AND semesters.term = 'S2'
AND course_enrolments.mark >= 50
AND course_enrolments.student = people.id
AND course_enrolments.course = courses.id
AND courses.semester = semesters.id
AND people.unswid = Q9_1.unswid;

create or replace view Q9_3
as 
select distinct Q9_2.unswid,Q9_2.name,program_enrolments.program,
avg(course_enrolments.mark)     
from Q9_2,people,semesters,courses,course_enrolments,program_enrolments     
where semesters.year <= '2010'  
AND course_enrolments.mark >= 50
AND course_enrolments.student = people.id 
AND program_enrolments.student = people.id 
AND Q9_2.unswid = people.unswid
AND course_enrolments.course = courses.id   
AND program_enrolments.semester = courses.semester  
AND courses.semester = semesters.id         
AND course_enrolments.student = program_enrolments.student
group by Q9_2.unswid,Q9_2.name,program_enrolments.program;

create or replace view Q9_4    
as 
select distinct Q9_2.unswid,Q9_2.name  
from Q9_2           
except
select distinct Q9_3.unswid,Q9_3.name
from Q9_3
where Q9_3.avg < 80;

create or replace view Q9_5 
as      
select distinct Q9_4.unswid,Q9_4.name,programs.uoc,sum(subjects.uoc)  
from Q9_4,people,courses,subjects,semesters,programs,  
course_enrolments,program_enrolments       
where Q9_4.unswid = people.unswid
AND semesters.year <= '2010'              
AND course_enrolments.mark >=50
AND courses.subject = subjects.id      
AND course_enrolments.student = people.id 
AND program_enrolments.student = people.id  
AND course_enrolments.student = program_enrolments.student     
AND program_enrolments.program = programs.id 
AND course_enrolments.course = courses.id    
AND courses.semester = semesters.id  
AND courses.semester = program_enrolments.semester  
group by Q9_4.unswid,Q9_4.name,programs.uoc;

create or replace view Q9(unswid, name)
as
select Q9_5.unswid,Q9_5.name 
from Q9_5   
where Q9_5.sum >= Q9_5.uoc;
--... SQL statements, possibly using other views/functions defined by you ...
;

-- Q10:
create or replace view Q10_1
as
select distinct rooms.unswid,rooms.longname,classes.id
from rooms,classes,courses,semesters,room_types
where room_types.description = 'Lecture Theatre'
AND semesters.year = '2011'
AND semesters.term = 'S1'
AND rooms.rtype = room_types.id
AND classes.room = rooms.id
AND semesters.id = courses.semester
AND classes.course = courses.id;

create or replace view Q10_2
as
select distinct Q10_1.unswid,Q10_1.longname,count(Q10_1.id)
from Q10_1
group by Q10_1.unswid,Q10_1.longname;

create or replace view Q10_3
as
select rooms.unswid,rooms.longname
from room_types,rooms
where room_types.description = 'Lecture Theatre'
AND rooms.rtype = room_types.id
except
select Q10_2.unswid,Q10_2.longname
from Q10_2;

create or replace view Q10_4
as
select distinct Q10_3.unswid,Q10_3.longname,0
from Q10_3;

create or replace view Q10_5
as
select Q10_2.unswid,Q10_2.longname,Q10_2.count
from Q10_2
union
select Q10_4.unswid,Q10_4.longname,0
from Q10_4;

create or replace view Q10(unswid, longname, num, rank)
as
select rooms.unswid,rooms.longname,Q10_5.count as num,
rank()over(order by Q10_5.count desc) as rank
from Q10_5,rooms
where Q10_5.unswid = rooms.unswid;

--... SQL statements, possibly using other views/functions defined by you ...
;
