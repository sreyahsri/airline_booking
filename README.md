# Airline Booking System

This project is an **Airline Booking System** built using **Flask** as the backend framework, **PostgreSQL** as the database, and **Stripe** for payment integration. The system allows users and travel agents to book flights, manage reservations, and handle payments securely.

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Database Structure](#database-structure)
- [Installation](#installation)
- [Setting Up the Database](#setting-up-the-database)
- [Stripe Payment Integration](#stripe-payment-integration)
- [Running the Application](#running-the-application)
- [Usage](#usage)
- [Future Enhancements](#future-enhancements)

## Features

- **User Authentication:** Users can log in using their passport ID.
- **Travel Agent Authentication:** Travel agents can log in using their agent ID.
- **Flight Booking:** Users can browse flights, select seats, and book flights.
- **Payment Integration:** Secure payments using **Stripe**.
- **Reservation Management:** Travel agents can view and manage flight reservations.
- **Real-time Flight Availability:** Dynamic display of available flights and seats.

## Technologies Used

- **Backend:** Flask (Python)
- **Frontend:** HTML, Bootstrap, JavaScript
- **Database:** PostgreSQL
- **Payment Integration:** Stripe
- **Other Dependencies:** psycopg2 (PostgreSQL driver for Python), Stripe Python SDK

## Database Structure

The system uses a PostgreSQL database with the following entities:

1. **Reserves:** Stores reservation details with a unique PNR number.
2. **Airport:** Stores airport names and codes.
3. **Airline Company:** Stores airline company names and IDs.
4. **Airplane:** Contains details about the airplane (e.g., seating capacity, type).
5. **Seat:** Stores information about seat number, type, class, and location.
6. **Hop:** Stores information about individual legs (hops) in a flight trip.
7. **User:** Stores user details such as passport ID, name, phone number, and DOB.
8. **Travel Agent:** Stores travel agent details such as ID, name, and contact.
9. **Flight Trip:** Stores details about the flight trip (e.g., source, destination, times).
10. **Fare:** Stores the fare details such as base price, tax, discount, and final amount.

### ER Diagram (Conceptual)

```plaintext
User -- Reserves -- Flight Trip -- Hop
Travel Agent -- Reserves -- Seat -- Airplane -- Airline Company
Airport -- Hop (Source and Destination)

### Installation 

1. Clone the repository: 
    git clone https://github.com/your-username/airline-booking-system.git
    cd airline-booking-system

2. Create a virtual environment and activate it:
    python -m venv venv
    source venv/bin/activate  # On Windows: venv\Scripts\activate

3. Install the required packages:
    pip install -r requirements.txt

4. Install PostgreSQL and set up your PostgreSQL server

### Setting Up the Database

1. Create the database in PostgreSQL
    CREATE DATABASE airline_booking;

2. Connect to the database:
    psql -U postgres -d airline_booking

3. Run the provided SQL script to create tables and insert sample data:
    -- Example SQL queries
    CREATE TABLE Users (
        passport_id VARCHAR(10) PRIMARY KEY,
        name VARCHAR(100),
        phone_number VARCHAR(15),
        dob DATE
    );

    -- Follow the table definitions and relationships as per the project.

4. Update the app.py file with your PostgreSQL credentials:

    conn = psycopg2.connect(database="airline_booking", user="your_username", password="your_password", host="localhost", port="5432")

### Stripe Payment Integration

1. Create a Stripe account at Stripe and get your Publishable Key and Secret Key.
2. Update the Stripe keys in app.py:
    stripe.api_key = "your_secret_key_here"
3. You can use Stripe's test mode for testing payments. You can find test card numbers in the Stripe documentation, such as 4242 4242 4242 4242 for successful payments.

### Running the Application

1. Start the Flask application:
    python app.py
2. Access the app in your browser at http://127.0.0.1:5000

### Usage

1. Homepage:
    Choose between User Login, Agent Login or Book a Flight

2. User Login:
    Log in using your passport ID
    After login, browse available flights and select seats

3. Booking a Flight:
    Once you've selected a flight and seat, you will be directed to the Stripe payment page.
    Enter payment details and confirm the booking.
    On successful payment, you'll receive a confirmation message.

4. Travel Agent Login:
    Travel agents can log in using their agent ID
    Agents can view and manage reservations, including passenger details and seat assignments.


