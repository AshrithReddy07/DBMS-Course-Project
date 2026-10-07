CREATE DATABASE IF NOT EXISTS gym_management;

USE gym_management;

CREATE TABLE Member (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    gender VARCHAR(10),
    join_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE Membership (
    membership_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    plan_name VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (member_id)
        REFERENCES Member(member_id)
);

CREATE TABLE Trainer (
    trainer_id INT PRIMARY KEY AUTO_INCREMENT,
    trainer_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE,
    experience_years INT
);

CREATE TABLE Fitness_Session (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    trainer_id INT NOT NULL,
    session_name VARCHAR(100) NOT NULL,
    session_date DATE NOT NULL,
    session_time TIME NOT NULL,
    capacity INT NOT NULL,
    FOREIGN KEY (trainer_id)
        REFERENCES Trainer(trainer_id)
);

CREATE TABLE Booking (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    session_id INT NOT NULL,
    booking_date DATE NOT NULL,
    booking_status VARCHAR(20) DEFAULT 'Booked',
    FOREIGN KEY (member_id)
        REFERENCES Member(member_id),
    FOREIGN KEY (session_id)
        REFERENCES Fitness_Session(session_id)
);

INSERT INTO Member
(name, phone, email, gender, join_date, status)
VALUES
('Rahul Sharma','9876543210','rahul@gmail.com','Male','2026-01-10','Active'),
('Arjun Reddy','9876543211','arjun@gmail.com','Male','2026-01-15','Active'),
('Priya Singh','9876543212','priya@gmail.com','Female','2026-02-01','Active'),
('Neha Rao','9876543213','neha@gmail.com','Female','2026-02-10','Active'),
('Karan Kumar','9876543214','karan@gmail.com','Male','2026-02-20','Inactive');

INSERT INTO Membership
(member_id, plan_name, start_date, end_date, amount, status)
VALUES
(1,'Monthly','2026-01-10','2026-02-10',1500,'Expired'),
(2,'Quarterly','2026-01-15','2026-04-15',4000,'Active'),
(3,'Monthly','2026-02-01','2026-03-01',1500,'Expired'),
(4,'Yearly','2026-02-10','2027-02-10',12000,'Active'),
(5,'Monthly','2026-02-20','2026-03-20',1500,'Expired');

INSERT INTO Trainer
(trainer_name, specialization, phone, experience_years)
VALUES
('Vikram Rao','Strength Training','9000000001',5),
('Aman Khan','Yoga','9000000002',4),
('Sneha Patel','Cardio','9000000003',6),
('Rohit Das','CrossFit','9000000004',7),
('Anjali Mehta','Pilates','9000000005',3);

INSERT INTO Fitness_Session
(trainer_id, session_name, session_date, session_time, capacity)
VALUES
(1,'Strength Training','2026-10-07','07:00:00',20),
(2,'Morning Yoga','2026-10-07','08:00:00',15),
(3,'Cardio Blast','2026-10-07','17:00:00',20),
(4,'CrossFit Training','2026-10-08','18:00:00',15),
(5,'Pilates Session','2026-10-08','19:00:00',12);

INSERT INTO Booking
(member_id, session_id, booking_date, booking_status)
VALUES
(1,1,'2026-10-01','Booked'),
(2,2,'2026-10-01','Booked'),
(3,3,'2026-10-02','Booked'),
(4,4,'2026-10-02','Booked'),
(5,5,'2026-10-03','Cancelled');

-- JOIN QUERY 1
SELECT m.name, ms.plan_name, ms.amount, ms.status
FROM Member m
JOIN Membership ms
ON m.member_id = ms.member_id;

-- JOIN QUERY 2
SELECT m.name, s.session_name, s.session_date,
       s.session_time, b.booking_status
FROM Booking b
JOIN Member m
ON b.member_id = m.member_id
JOIN Fitness_Session s
ON b.session_id = s.session_id;

-- AGGREGATE QUERY 1
SELECT plan_name, COUNT(*) AS total_members
FROM Membership
GROUP BY plan_name;

-- AGGREGATE QUERY 2
SELECT AVG(amount) AS average_membership_fee
FROM Membership;

-- AGGREGATE QUERY 3
SELECT t.trainer_name,
       COUNT(s.session_id) AS total_sessions
FROM Trainer t
LEFT JOIN Fitness_Session s
ON t.trainer_id = s.trainer_id
GROUP BY t.trainer_id, t.trainer_name;