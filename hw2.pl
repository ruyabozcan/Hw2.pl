

% Facts:
department(cs).	department(ee).
student(jane).		student(tom).		student(ann).
instructor(paul).	instructor(joan).	instructor(janet).
course(cs303).		course(cs444).		course(cs104).
enrolled(jane, cs303).		enrolled(jane, cs444).
enrolled(tom, cs104).
enrolled(ann, cs303).		enrolled(ann, cs444).
teaches(paul, cs303).
teaches(joan, cs303).		teaches(joan, cs444).
teaches(janet, cs104).

exam(cs104, qz1, 0.1).	exam(cs104, mt, 0.35).	exam(cs104, fin, 0.55).
exam(cs303, qz1, 0.1).	exam(cs303, mt, 0.4).	exam(cs303, fin, 0.5).
exam(cs444, mt, 0.4).	exam(cs444, fin, 0.6).

grade(jane, cs303, qz1, 80).
grade(jane, cs303, mt, 74).
grade(jane, cs303, fin, 92).
grade(jane, cs444, mt, 84).
grade(jane, cs444, fin, 87).
grade(tom, cs104, qz1, 68).
grade(tom, cs104, mt, 77).
grade(tom, cs104, fin, 82).
grade(ann, cs303, qz1, 62).
grade(ann, cs303, mt, 68).
grade(ann, cs303, fin, 77).
grade(ann, cs444, mt, 67).
grade(ann, cs444, fin, 71).

% Rules:
% List of departments:
deptList(DeptList) :- setof(Dept, department(Dept), DeptList).
% List of students:
stuList(StuList) :- setof(Stu, student(Stu), StuList).
% List of courses:
crsList(CrsList) :- setof(Crs, course(Crs), CrsList).
% List of instructors:
instrList(InstrList) :- setof(Instr, instructor(Instr), InstrList).

% Student enrolled to a course:
courseStu(Crs, StuList) :- bagof(Stu, enrolled(Stu, Crs), StuList).

% All courses taken by a student
stuCourses(Stu, CourseList) :- setof(Crs, enrolled(Stu, Crs), CourseList).

% All courses taught by an instructor
instrCourses(Instructor, CourseList) :-
    setof(Course, teaches(Instructor, Course), CourseList).

% Exams and weights of a course:
crsExams(Crs, Exams) :- 
    bagof((Exam, W), exam(Crs, Exam, W), Exams).

% Exams and grades of a student in a course:
stuExamGr(Stu, Crs, EGList) :- 
    bagof((Exam, Gr), grade(Stu, Crs, Exam, Gr), EGList).

% Exams of a student in a course:
stuExams(Stu, Crs, Exams) :- 
    findall(Exam, grade(Stu, Crs, Exam, _), Exams).

% (Grades, Weights) of a student in a course.
stuGradesW(Stu, Crs, GrWList) :- 
    findall((Gr, W), (grade(Stu, Crs, Exam, Gr), exam(Crs, Exam, W)), GrWList).

% Grades*Weights of a student in a course.
stuGradesM(Stu, Crs, GrWList) :- 
    findall(Gr*W, (grade(Stu, Crs, Exam, Gr), exam(Crs, Exam, W)), GrWList).

overall(Stu, Crs, Total) :- 
    stuGradesM(Stu, Crs, A), sum_list(A, Total).

printOverall(Stu, Crs) :- overall(Stu, Crs, Total), write(Total).
printStuExams(Stu, Crs) :- stuExams(Stu, Crs, Exams), write(Stu), write(" "), 
    write(Crs), write(": "), write(Exams).
printStuExamGr(Stu, Crs) :- stuExamGr(Stu, Crs, GrList), write(Stu), write(" "), 
    write(Crs), write(": "), write(GrList).

/* Queries and Answers:
% Get a list of students.
?- stuList(StuList).
	StuList = [ann, jane, tom]

% Get a list of courses.
?- crsList(CrsList).
	CrsList = [cs104, cs303, cs444]

% What are the courses Jane is enrolled to?
?- stuCourses(jane, CrsList).
	CrsList = [cs303, cs444]

% List of students enrolled to CS303:
?- courseStu(cs303, StuList).
	StuList = [ann, jane]

% What are the courses taught by Joan?
?- instrCourses(joan, CourseList).
	CourseList = [cs303, cs444]

% Exams and weights of CS303:
?- crsExams(cs303, Exams).
	Exams = [(qz1,0.1), (mt,0.4), (fin,0.5)]

% Which CS303 exams Jane took?
?- stuExams(jane, cs303, Exams).
	Exams = [qz1, mt, fin]

% What are the exams and grades of Jane in CS303?
?- stuExamGr(jane, cs303, EGList).
	EGList = [(qz1,80), (mt,74), (fin,92)]

% What are the exams and grades of Jane in all courses?
?- stuExamGr(jane, Crs, EGList).
	Crs = cs303	EGList = [(qz1,80), (mt,74), (fin,92)]
	Crs = cs444	EGList = [(mt,84), (fin,87)]

% What is Jane's overall grade in CS303.
?- overall(jane, cs303, Overall).
	Overall = 83.6
*/
