CREATE DATABASE Grosvenor;
use Grosvenor;

create table hotel(
	hotel_no varchar(50) not null,
    hotelname varchar(50) not null,
    address varchar(200) not null,
    primary key (hotel_no)
);
insert into hotel(hotel_no,hotelname,address) values 
('H101', 'Grosvenor Hotel', 'London'),
('H102', 'Royal Lancaster', 'London'),
('H103', 'Park Grand', 'Mumbai'),
('H201', 'Grosvenor Hotel', 'London'),
('H202', 'Trident', 'Hyderabad'),
('H203', 'Taj Banjara', 'Hyderabad'),
('H204', 'Vivanta', 'Hyderabad'),
('H301', 'Grosvenor Hotel', 'London'),
('H302', 'Taj Banjara', 'London');
#drop table hotel;
select* from hotel;

create table Room(
	hotel_no varchar(50) not null,
    room_no varchar(50) not null primary key,
    room_type varchar(200) not null,
    price decimal(5,2) not null,
    no_rooms_ocuupied int,
    foreign key (hotel_no) references hotel(hotel_no) ON DELETE CASCADE
);
insert into Room(hotel_no,room_no,room_type,price,no_rooms_ocuupied) values 
('H101','1', 'S', 72.00,1),
('H102','2', 'F', 82.00,3),
('H103','3', 'D', 90.00,2),
('H201','4', 'D', 80.00,2),
('H202','5', 'F', 75.00,3),
('H203','6', 'S', 60.00,1),
('H204','7', 'D', 68.00,2),
('H301', '8','D',74.35,2),
('H302','9','S',64.50,1);
select * from room;
#drop table room;


create table Guest(
	guest_no varchar(50) not null,
    guestname varchar(50) not null,
    address varchar(200) not null,
    primary key (guest_no)
);
insert into Guest(guest_no,guestname,address) values 
	('G1', 'John Smith', 'London'),
    ('G2', 'John william', 'London'),
    ('G3', 'peter oliver' , 'London'),
    ('G4', 'Rajitha Ramineni', 'Mumbai'),
    ('G5', 'Sravani varma', 'Hyderabad'),
    ('G6', 'saritha palla', 'Mumbai'),
    ('G7', 'sharanya Reddy', 'Hyderabad'),
    ('G8', 'shanaya nandan', 'London'),
    ('G9', 'jayan varma', 'Delhi'); 
select * from guest;
#drop table guest;


create table Booking(
	hotel_no varchar(50) not null unique,
    guest_no varchar(50) not null,
    fromdate date not null,
    todate date default null,
    room_no varchar(50) not null unique,
    foreign key (guest_no) references Guest(guest_no) ON DELETE CASCADE on update cascade,
 
    foreign key (room_no) references room(room_no) ON DELETE CASCADE on update cascade,
	PRIMARY KEY (guest_no,hotel_no)
);
insert into Booking(hotel_no,guest_no,fromdate,todate,room_no) values 
('H101', 'G1','1999-01-01','1999-01-02', '1'),
('H102', 'G2','1998-10-01','1998-10-06', '2'),
('H103', 'G3','2000-12-01','2000-12-10', '3'),
('H201', 'G4','1995-01-01',null, '4'),
('H202', 'G5','2022-10-06',current_date(), '5'),
('H203', 'G6','2020-01-01','2020-01-02', '6'),
('H204', 'G7','2022-01-01','2022-01-05', '7'),
('H301', 'G8','2022-10-07',current_date(), '8'),
('H302', 'G9','2022-01-01',null, '9');
select * from booking;
#drop table booking;

alter table room add constraint `room_fk`
foreign key (hotel_no) references Hotel(hotel_no) on update cascade;
update room set price=price*1.05 where price <90;

create table bookingrecordsold(
hotel_no varchar(50) not null unique,
    guest_no varchar(50) not null,
    fromdate date not null,
    todate date,
    room_no varchar(50) not null unique);
    insert into bookingrecordsold(hotel_no,guest_no,fromdate,todate,room_no) select * from booking 
    where year(fromdate)<2000; 
select * from bookingrecordsold;

alter table booking add constraint `booking_fk`
foreign key (hotel_no) references hotel(hotel_no) on delete cascade;
delete from booking where year(fromdate) <2000;
select * from booking;
			#or--
create table newrecords(
hotel_no varchar(50) not null unique,
    guest_no varchar(50) not null,
    fromdate date not null,
    todate date,
    room_no varchar(50) not null unique);
insert into newrecords(hotel_no,guest_no,fromdate,todate,room_no) select * from booking 
    where year(fromdate)>=2000;

/*
Simple Queries

1. List full details of all hotels.

2. List full details of all hotels in London.

3. List the names and addresses of all guests in London, alphabetically ordered by name.

4. List all double or family rooms with a price below £40.00 per night, in ascending order of price.

5. List the bookings for which no date_to has been specified.
*/
#1. List full details of all hotels.
select * from hotel;

#2. List full details of all hotels in London.
select * from hotel where address='London';

#3. List the names and addresses of all guests in London, alphabetically ordered by name.
select guestname,address from guest where address='London' order by guestname asc;

#4. List all double or family rooms with a price below £80.00 per night, in ascending order of price.
select room_type as 'double or family rooms',price from room 
where price<80 and room_type in ('D','F') order by price asc;

#5. List the bookings for which no date_to has been specified.
select * from booking where todate is null;

/*
Aggregate Functions

1. How many hotels are there?

2. What is the average price of a room?

3. What is the total revenue per night from all double rooms?

4. How many different guests have made bookings for August?
*/
#1. How many hotels are there?
select count(*) no_of_hotels from hotel; 

#2. What is the average price of a room?
select avg(price) avg_price_of_room from room;

#3. What is the total revenue per night from all double rooms?
select sum(price) total_revenue from room where room_type='D';

#4. How many different guests have made bookings for January?
select guest_no,fromdate from booking where month(fromdate)=1;

/*
Subqueries and Joins

1. List the price and type of all rooms at the Grosvenor Hotel.

2. List all guests currently staying at the Grosvenor Hotel.

3. List the details of all rooms at the Grosvenor Hotel, including the name of the guest staying in the

room, if the room is occupied.

4. What is the total income from bookings for the Grosvenor Hotel today?

5. List the rooms that are currently unoccupied at the Grosvenor Hotel.

6. What is the lost income from unoccupied rooms at the Grosvenor Hotel?
*/
#1. List the price and type of all rooms at the Grosvenor Hotel.
select hotelname,room_type,price from hotel 
	join room on hotel.hotel_no=room.hotel_no where hotelname='Grosvenor Hotel';
    
#2. List all guests currently staying at the Grosvenor Hotel.
select hotelname,(select guestname from guest g where g.guest_no=b.guest_no) guestname,
	fromdate,todate from hotel h join 
	booking b on h.hotel_no=b.hotel_no where hotelname='Grosvenor Hotel' and todate=current_date();
    
#3. List the details of all rooms at the Grosvenor Hotel, including the name of the guest staying in the room, if the room is occupied.
select r.room_no,hotelname,
	room_type,(select guestname from guest g where b.guest_no=g.guest_no) guestname from room r 
    join booking b on r.room_no=b.room_no
    join hotel h on b.hotel_no=h.hotel_no
	where hotelname='Grosvenor Hotel' and (room_type ='D' or room_type='F');

#4. What is the total income from bookings for the Grosvenor Hotel today?
select sum(price) 'total income' from room r 
	join hotel h on r.hotel_no=h.hotel_no where hotelname='Grosvenor Hotel' and (room_type ='D' or room_type='F');
    
#5. List the rooms that are currently unoccupied at the Grosvenor Hotel.
select r.room_no,room_type,hotelname from room r 
	join hotel h on r.hotel_no=h.hotel_no
    join booking b on r.room_no=b.room_no
    where hotelname='Grosvenor Hotel' and room_type ='S';
    
#6. What is the lost income from unoccupied rooms at the Grosvenor Hotel?
select hotelname,room_type, sum(price) as lost_income from hotel h 
	join booking b on h.hotel_no=b.hotel_no
    join room r on b.room_no=r.room_no
    where hotelname='Grosvenor Hotel' and room_type='S';

/*
Grouping

1. List the number of rooms in each hotel.

2. List the number of rooms in each hotel in London.

3. What is the average number of bookings for each hotel in August?

4. What is the most commonly booked room type for each hotel in London?

5. What is the lost income from unoccupied rooms at each hotel today?
*/

#1. List the number of rooms in each hotel.
select hotelname,count(*) as 'no of rooms' from hotel h 
	join room r on h.hotel_no=r.hotel_no
    group by hotelname order by count(*) desc;
    
#2. List the number of rooms in each hotel in London.
select address,hotelname,count(*) no_of_rooms from hotel h 
	join room r on h.hotel_no=r.hotel_no
    group by hotelname
    having address='London';
    
#3. What is the average number of bookings for each hotel in january?
select hotelname,fromdate,avg(no_rooms_ocuupied) no_of_bookings from room r 
	join hotel h on r.hotel_no=h.hotel_no
    join booking b on h.hotel_no=b.hotel_no
    where month(fromdate)='01'
    group by hotelname;
    

    
#4. What is the most commonly booked room type for each hotel in London?
select room_type,hotelname,address from room r 
	join hotel h on r.hotel_no=h.hotel_no
    group by hotelname
    having h.address='London';

#5. What is the lost income from unoccupied rooms at each hotel today?
select hotelname,sum(price) lost_income,room_type from hotel h 
	join room r on h.hotel_no=r.hotel_no
    where r.room_type='S'
    group by hotelname ;
    
select * from booking;
select * from bookingrecords;

#display the persons who stayed most of the time in a hotel
select guestname,row_number() over(order by t.diff desc) rno,
	datediff(todate,fromdate) diff,fromdate,todate from 
	(select guestname,datediff(todate,fromdate) diff,fromdate,todate from booking b
	join guest g on b.guest_no=g.guest_no) t limit 3;

#display the total revenue generate by each hotel
select hotelname,sum(no_rooms_ocuupied) rooms_occupied,price price_per_room
from hotel h
join room r on h.hotel_no=r.hotel_no
where r.room_type in ('D','F')
group by hotelname
order by rooms_occupied desc;

create temporary table tduration
select t2.hotel_no,t2.guestname,t2.diff from
(select hotel_no,guestname,row_number() over(order by t.diff desc) rno,
	datediff(todate,fromdate) diff from 
	(select b.hotel_no,guestname,datediff(todate,fromdate) diff,fromdate,todate from booking b
	join guest g on b.guest_no=g.guest_no) t where t.diff is not null) t2 ;
select * from tduration;

select guestname,price price_per_room,datediff(todate,fromdate) duration,room_type,
row_number() over(order by datediff(todate,fromdate) desc) trevenue
from room r join 
	booking b on r.hotel_no=b.hotel_no 
    join tduration td on r.hotel_no=td.hotel_no
    where datediff(todate,fromdate) is not null and room_type in('D','F');


select t.*,rooms_occupied*price_per_room totalrevenue from
(select hotelname,sum(no_rooms_ocuupied) rooms_occupied,price price_per_room from hotel h
join room r on h.hotel_no=r.hotel_no
where r.room_type in ('D','F')
group by hotelname
order by rooms_occupied desc) t ;

select t.*,rooms_occupied*price_per_room totalrevenue from
(select hotelname,sum(no_rooms_ocuupied) rooms_occupied,price price_per_room,
	fromdate,todate from hotel h
	join room r on h.hotel_no=r.hotel_no 
    join booking b on r.hotel_no=b.hotel_no
    where r.room_type in ('D','F')
    group by hotelname 
    order by rooms_occupied desc) t ;
 
