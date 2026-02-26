CREATE TABLE Student (
    SID INT PRIMARY KEY,
    SNAME VARCHAR(100),
    Faculty VARCHAR(100)
);

CREATE TABLE Courses (
    CID INT PRIMARY KEY,
    CNAME VARCHAR(100),
    CreditHour INT
);

CREATE TABLE Enrollment (
    CID INT,
    SID INT,
    Semester VARCHAR(50),
    FOREIGN KEY (CID) REFERENCES Courses(CID),
    FOREIGN KEY (SID) REFERENCES Student(SID)
);

INSERT INTO Student (SID, SNAME, Faculty) VALUES 
(1, 'John Doe', 'Computer Science'), 
(2, 'Jane Smith', 'Mathematics'), 
(3, 'Alice Brown', 'Physics'), 
(4, 'Bob Johnson', 'Chemistry'); 

INSERT INTO Courses (CID, CNAME, CreditHour) VALUES 
(101, 'Database Systems', 3), 
(102, 'Calculus I', 4), 
(103, 'Quantum Mechanics', 3), 
(104, 'Organic Chemistry', 4); 

INSERT INTO Enrollment (CID, SID, Semester) VALUES 
(101, 1, 'Fall'), 
(102, 2, 'Spring'), 
(101, 3, 'Fall'), 
(101, 4, 'Spring'), 
(103, 1, 'Spring'); 

SELECT * FROM Student 
WHERE SID NOT IN (SELECT SID FROM Enrollment);

SELECT * FROM Courses 
WHERE CID NOT IN (SELECT CID FROM Enrollment);

SELECT * FROM Student 
WHERE SID > (SELECT AVG(SID) FROM Student);

SELECT SNAME 
FROM Student 
WHERE SID IN (
    SELECT SID 
    FROM Enrollment 
    WHERE CID IN (
        SELECT CID 
        FROM Enrollment 
        WHERE SID = (SELECT SID FROM Student WHERE SNAME = 'John Doe')
    )
) AND SNAME != 'John Doe';

SELECT * FROM Courses 
WHERE CID IN (
    SELECT CID FROM Enrollment WHERE Semester = 'Fall'
    INTERSECT
    SELECT CID FROM Enrollment WHERE Semester = 'Spring'
);