from flask import Flask, request, jsonify
from datetime import datetime, timedelta
import pandas as pd

app = Flask(__name__)


df = pd.read_excel('appointments.xlsx', parse_dates=['Appointment Start Time', 'Appointment Over Time'])

df['Duration'] = (df['Appointment Over Time'] - df['Appointment Start Time']).dt.total_seconds() / 60

average_duration = df['Duration'].mean()

@app.route('/predict_waiting_time', methods=['POST'])
def predict_waiting_time():
    data = request.json

    current_number = data.get('current_number')
    user_number = data.get('user_number')

    print(current_number)

    print(user_number)
    current_time_str = datetime.now().strftime('%I:%M %p')


    people_in_front = user_number - current_number

    waiting_time = people_in_front * average_duration

    predicted_time = datetime.now() + timedelta(minutes=waiting_time)

    return jsonify({
        'user_number': user_number,
        'predicted_waiting_time': predicted_time.strftime('%I:%M %p'),
        'current_time': current_time_str
    })

if __name__ == '__main__':
    app.run(debug=True)
