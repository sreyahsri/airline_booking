drop database airline_booking;
create database airline_booking;
\c airline_booking
-- Create Users Table
CREATE TABLE Users (
    passport_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    gender VARCHAR(10),
    phone_number VARCHAR(15),
    date_of_birth DATE
);

-- Create Airport Table
CREATE TABLE Airport (
    airport_id SERIAL PRIMARY KEY,
    airport_name VARCHAR(100),
    airport_code VARCHAR(10)
);

-- Create Airline Company Table
CREATE TABLE AirlineCompany (
    airline_id SERIAL PRIMARY KEY,
    company_name VARCHAR(100)
);

-- Create Airplane Table
CREATE TABLE Airplane (
    airplane_id SERIAL PRIMARY KEY,
    airline_id INT REFERENCES AirlineCompany(airline_id),
    seating_capacity INT,
    aircraft_type VARCHAR(50)
);

-- Create Seat Table
CREATE TABLE Seat (
    seat_id SERIAL PRIMARY KEY,
    airplane_id INT REFERENCES Airplane(airplane_id),
    seat_number VARCHAR(10),
    seat_type VARCHAR(20),
    class VARCHAR(20),
    available BOOLEAN DEFAULT TRUE
);

-- Create Hop Table
CREATE TABLE Hop (
    hop_id SERIAL PRIMARY KEY,
    distance INT,
    arrival_airport INT REFERENCES Airport(airport_id),
    departure_airport INT REFERENCES Airport(airport_id),
    arrival_time TIMESTAMP,
    departure_time TIMESTAMP
);

-- Create FlightTrip Table
CREATE TABLE FlightTrip (
    flight_trip_id SERIAL PRIMARY KEY,
    number_of_passengers INT,
    departure_time TIMESTAMP,
    arrival_time TIMESTAMP,
    source INT REFERENCES Airport(airport_id),
    intermediate_destination INT REFERENCES Airport(airport_id),
    destination INT REFERENCES Airport(airport_id)
);

-- Create Fare Table
CREATE TABLE Fare (
    fare_price SERIAL PRIMARY KEY,
    tax DECIMAL(10, 2),
    discount DECIMAL(10, 2),
    fare_type VARCHAR(20),
    final_amount DECIMAL(10, 2)
);

-- Create Reserves Table
CREATE TABLE Reserves (
    pnr_number SERIAL PRIMARY KEY,
    flight_trip_id INT REFERENCES FlightTrip(flight_trip_id),
    passport_id INT REFERENCES Users(passport_id)
);

-- Create TravelingAgent Table
CREATE TABLE TravelingAgent (
    agent_id SERIAL PRIMARY KEY,
    contact_number VARCHAR(15),
    name VARCHAR(100),
    company_name VARCHAR(100)
);
