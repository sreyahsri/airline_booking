from flask import Flask, render_template, request, redirect, jsonify
import psycopg2
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from flask_mail import Mail, Message
from flask_socketio import SocketIO, emit
import stripe

app = Flask(__name__)
app.config['SECRET_KEY'] = 'your_secret_key'
app.config['JWT_SECRET_KEY'] = 'your_jwt_secret_key'

# Initialize JWT
jwt = JWTManager(app)

# Stripe Configuration
stripe.api_key = "your_stripe_secret_key"

# Mail Configuration
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USERNAME'] = 'your_email@gmail.com'
app.config['MAIL_PASSWORD'] = 'your_email_password'
app.config['MAIL_USE_TLS'] = False
app.config['MAIL_USE_SSL'] = True
mail = Mail(app)

# Initialize SocketIO for real-time updates
socketio = SocketIO(app)

# Connect to PostgreSQL
conn = psycopg2.connect(database="airline_booking", user="your_username", password="your_password", host="localhost", port="5432")
cur = conn.cursor()

# User login with JWT token generation
@app.route('/user_login', methods=['POST'])
def user_login():
    passport_id = request.form['passport_id']
    cur.execute("SELECT * FROM Users WHERE passport_id=%s", (passport_id,))
    user = cur.fetchone()
    if user:
        access_token = create_access_token(identity=passport_id)
        return jsonify(access_token=access_token)
    else:
        return jsonify({"error": "User not found"}), 401

# Admin login with JWT
@app.route('/admin_login', methods=['POST'])
def admin_login():
    admin_user = request.form['username']
    admin_pass = request.form['password']
    if admin_user == 'admin' and admin_pass == 'admin123':
        access_token = create_access_token(identity=admin_user)
        return jsonify(access_token=access_token)
    else:
        return jsonify({"error": "Invalid admin credentials"}), 401

# Booking flights (JWT protected route)
@app.route('/book_flight', methods=['GET'])
@jwt_required()
def book_flight():
    current_user = get_jwt_identity()
    cur.execute("SELECT * FROM FlightTrip")
    flights = cur.fetchall()
    cur.execute("SELECT * FROM Seat WHERE available = TRUE")
    seats = cur.fetchall()
    return render_template('book_flight.html', flights=flights, seats=seats)

# Add new flights (admin only)
@app.route('/add_flight', methods=['POST'])
@jwt_required()
def add_flight():
    source = request.form['source']
    destination = request.form['destination']
    departure_time = request.form['departure_time']
    cur.execute("INSERT INTO FlightTrip (source, destination, departure_time) VALUES (%s, %s, %s)", 
                (source, destination, departure_time))
    conn.commit()
    return redirect('/admin_dashboard')

# Search for flights
@app.route('/search_flights', methods=['POST'])
def search_flights():
    source = request.form['source']
    destination = request.form['destination']
    departure_date = request.form['departure_date']
    cur.execute("SELECT * FROM FlightTrip WHERE source=%s AND destination=%s AND departure_time::date=%s", 
                (source, destination, departure_date))
    flights = cur.fetchall()
    return render_template('book_flight.html', flights=flights)

# User dashboard route
@app.route('/user_dashboard', methods=['GET'])
@jwt_required()
def user_dashboard():
    current_user = get_jwt_identity()
    
    # Fetch user information
    cur.execute("SELECT * FROM Users WHERE passport_id=%s", (current_user,))
    user_info = cur.fetchone()

    # Fetch user's booked flights
    cur.execute("""
        SELECT ft.flight_trip_id, ft.source, ft.destination, ft.departure_time, ft.arrival_time
        FROM FlightTrip ft
        JOIN Reserves r ON ft.flight_trip_id = r.flight_trip_id
        WHERE r.passport_id = %s
    """, (current_user,))
    bookings = cur.fetchall()

    return render_template('user_dashboard.html', user_info=user_info, bookings=bookings)


# Stripe payment success
@app.route('/payment_success', methods=['POST'])
def payment_success():
    # Stripe payment confirmation here...
    user_email = 'user_email@example.com'
    send_confirmation(user_email)
    return "Payment successful! Your flight is booked."

# Sending confirmation email
def send_confirmation(user_email):
    msg = Message("Booking Confirmation", sender="your_email@gmail.com", recipients=[user_email])
    msg.body = "Your booking has been successfully confirmed."
    mail.send(msg)

# Get seat status via Socket.IO
@app.route('/seat_status/<flight_trip_id>', methods=['GET'])
def get_seat_status(flight_trip_id):
    cur.execute("SELECT seat_id, available FROM Seat WHERE flight_trip_id=%s", (flight_trip_id,))
    seats = cur.fetchall()
    return jsonify(seats=seats)

# Book seat and update real-time
@socketio.on('book_seat')
def book_seat(data):
    seat_id = data['seat_id']
    cur.execute("UPDATE Seat SET available=FALSE WHERE seat_id=%s", (seat_id,))
    conn.commit()
    emit('seat_update', {'seat_id': seat_id, 'available': False}, broadcast=True)

# Admin dashboard route
@app.route('/admin_dashboard', methods=['GET'])
@jwt_required()
def admin_dashboard():
    return render_template('admin_dashboard.html')

# Start the Flask application with SocketIO support
if __name__ == '__main__':
    socketio.run(app, debug=True)
