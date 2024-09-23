\c airline_booking

-- Insert into Users
INSERT INTO Users (name, gender, phone_number, date_of_birth) VALUES
('John Doe', 'Male', '1234567890', '1990-01-01'),
('Jane Smith', 'Female', '0987654321', '1992-05-15'),
('Alice Johnson', 'Female', '1122334455', '1985-07-20'),
('Bob Brown', 'Male', '2233445566', '1988-03-30'),
('Charlie Davis', 'Male', '3344556677', '1995-12-12');

-- Insert into Airport
INSERT INTO Airport (airport_name, airport_code) VALUES
('John F. Kennedy International Airport', 'JFK'),
('Los Angeles International Airport', 'LAX'),
('O’Hare International Airport', 'ORD'),
('San Francisco International Airport', 'SFO'),
('Dallas/Fort Worth International Airport', 'DFW');

-- Insert into Airline Company
INSERT INTO AirlineCompany (company_name) VALUES
('Delta Airlines'),
('American Airlines'),
('United Airlines');

-- Insert into Airplane
INSERT INTO Airplane (airline_id, seating_capacity, aircraft_type) VALUES
(1, 180, 'Commercial'),
(2, 200, 'Commercial'),
(3, 150, 'Cargo');

-- Insert into Seat
INSERT INTO Seat (airplane_id, seat_number, seat_type, class, available) VALUES
(1, '1A', 'Window', 'Business', TRUE),
(1, '1B', 'Aisle', 'Business', TRUE),
(1, '2A', 'Window', 'Economy', TRUE),
(1, '2B', 'Aisle', 'Economy', TRUE),
(2, '1A', 'Window', 'Business', TRUE),
(2, '1B', 'Aisle', 'Business', TRUE),
(2, '2A', 'Window', 'Economy', TRUE),
(2, '2B', 'Aisle', 'Economy', TRUE),
(3, '1', 'Cargo', 'Cargo', TRUE);

-- Insert into Hop
INSERT INTO Hop (distance, arrival_airport, departure_airport, arrival_time, departure_time) VALUES
(100, 1, 2, '2023-09-23 10:00:00', '2023-09-23 09:00:00'),
(200, 2, 3, '2023-09-23 15:00:00', '2023-09-23 14:00:00');

-- Insert into FlightTrip
INSERT INTO FlightTrip (number_of_passengers, departure_time, arrival_time, source, intermediate_destination, destination) VALUES
(150, '2023-09-23 08:00:00', '2023-09-23 11:00:00', 1, 2, 3),
(200, '2023-09-24 09:00:00', '2023-09-24 13:00:00', 2, NULL, 3);

-- Insert into Fare
INSERT INTO Fare (tax, discount, fare_type, final_amount) VALUES
(50.00, 5.00, 'One-way', 145.00),
(70.00, 10.00, 'Round-trip', 290.00);

-- Insert into Reserves
INSERT INTO Reserves (flight_trip_id, passport_id) VALUES
(1, 1),
(1, 2),
(2, 3);

-- Insert into TravelingAgent
INSERT INTO TravelingAgent (contact_number, name, company_name) VALUES
('3334445555', 'Mike Taylor', 'TravelCo'),
('6667778888', 'Sara Lee', 'FlyAway');
