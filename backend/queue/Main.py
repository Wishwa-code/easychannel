from flask import Flask, request, jsonify
from datetime import datetime, timedelta
import pandas as pd
import joblib
import numpy as np

app = Flask(__name__)


df = pd.read_excel('appointments.xlsx', parse_dates=['Appointment Start Time', 'Appointment Over Time'])

df['Duration'] = (df['Appointment Over Time'] - df['Appointment Start Time']).dt.total_seconds() / 60

average_duration = df['Duration'].mean()



# Load the saved model, LabelEncoders, StandardScaler, and RFE object
loaded_model = joblib.load('xgboost_model.pkl')
le_dict = {
    'Month': joblib.load('label_encoder_Month.pkl'),
    'AM_PM': joblib.load('label_encoder_AM_PM.pkl'),
    'Gender': joblib.load('label_encoder_Gender.pkl'),
    'Address': joblib.load('label_encoder_Address.pkl')
}
scaler = joblib.load('scaler.pkl')
rfe = joblib.load('rfe.pkl')

'''
# Get input for one patient
while True:
    print("Enter patient information:")

    month_input = input("Month (e.g., 'January'): ")
    working_day_input = input("Working day (True or False): ").lower() == "true"
    am_or_pm_input = input("AM or PM (morning or afternoon): ").lower()
    visit_no_input = int(input("Visit number: "))
    gender_input = input("Gender (M or F): ").upper()
    m_cancer_input = input("Malignant cancer (True or False): ").lower() == "true"
    s_cancer_input = input("Suspected cancer (True or False): ").lower() == "true"
    address_input = input("Address (In the city, Out of city, Out of province): ")

    # Create a DataFrame for the patient data
    patient_data = pd.DataFrame({
        'Month': [month_input],
        'WorkingDay': [working_day_input],
        'AM_PM': [am_or_pm_input],
        'Visit.No': [visit_no_input],
        'Gender': [gender_input],
        'M.Cancer': [m_cancer_input],
        'S.Cancer': [s_cancer_input],
        'Address': [address_input]
    })

    # Encode categorical features using the saved encoders
    for col in patient_data.select_dtypes(include='object'):
        try:
            patient_data[col] = le_dict[col].transform(patient_data[col])
        except KeyError as e:
            print(f"Warning: Unseen category '{e.args[0]}' in column '{col}'. Assigning a new category.")
            # Assign a new category
            new_category = len(le_dict[col].classes_)
            le_dict[col].classes_ = np.append(le_dict[col].classes_, e.args[0])
            patient_data[col] = le_dict[col].transform(patient_data[col])

    # Scale features using the saved scaler
    patient_data_scaled = scaler.transform(patient_data)

    # Select features with RFE
    patient_data_selected = rfe.transform(patient_data_scaled)

    # Make predictions using the trained model
    prediction_seconds = loaded_model.predict(patient_data_selected)[0]  # Extract single prediction
    print(prediction_seconds)
    
    prediction = prediction_seconds/60

    print(f"\nPredicted ServTime for this patient: {prediction:.2f} minutes\n")

    another_prediction = input("Predict for another patient? (yes/no): ").lower()
    if another_prediction != "yes":
        break

    '''


@app.route('/predict_waiting_time', methods=['POST'])
def predict_waiting_time():
    data = request.json
    print("meka",data)
    
    month_input = data.get('month_input')
    working_day_input = data.get('working_day_input', '').lower() == 'true'
    am_or_pm_input = "morning" if data.get('am_pm_input').lower() == 'true' else "afternoon"
    try:
        visit_no_input = int(data.get('visit_no_input', 0))
    except ValueError:
        # If conversion fails, set a default value or handle the error
        visit_no_input = 0  # or any other default value
        print(f"Invalid visit_no_input: {data.get('visit_no_input')}")
    gender_input = 'M' if data.get('gender_input', '').lower() == 'male' else 'F'
    m_cancer_input = data.get('m_cancer_input', '').lower() == 'true'
    s_cancer_input = data.get('s_cancer_input', '').lower() == 'true'
    address_input = data.get('address_input')
    
    print(month_input,  "|", working_day_input, "|", am_or_pm_input, "|", visit_no_input, "|", gender_input, "|", m_cancer_input, "|", s_cancer_input, "|", address_input )
    

    # Create a DataFrame for the patient data
    patient_data = pd.DataFrame({
        'Month': [month_input],
        'WorkingDay': [working_day_input],
        'AM_PM': [am_or_pm_input],
        'Visit.No': [visit_no_input],
        'Gender': [gender_input],
        'M.Cancer': [m_cancer_input],
        'S.Cancer': [s_cancer_input],
        'Address': [address_input]
    })

    # Encode categorical features using the saved encoders
    for col in patient_data.select_dtypes(include='object'):
        try:
            patient_data[col] = le_dict[col].transform(patient_data[col])
        except KeyError as e:
            print(f"Warning: Unseen category '{e.args[0]}' in column '{col}'. Assigning a new category.")
            # Assign a new category
            new_category = len(le_dict[col].classes_)
            le_dict[col].classes_ = np.append(le_dict[col].classes_, e.args[0])
            patient_data[col] = le_dict[col].transform(patient_data[col])

    # Scale features using the saved scaler
    patient_data_scaled = scaler.transform(patient_data)

    # Select features with RFE
    patient_data_selected = rfe.transform(patient_data_scaled)

    # Make predictions using the trained model
    prediction_seconds = loaded_model.predict(patient_data_selected)[0]  # Extract single prediction
    print(prediction_seconds)
    
    prediction_n_rounded = prediction_seconds/60
    prediction = round(prediction_n_rounded,2)

    print(f"\nPredicted ServTime for this patient: {prediction} minutes\n")
    
  
    '''
    current_number = data.get('current_number')
    user_number = data.get('user_number')
    
    current_time_str = datetime.now().strftime('%I:%M %p')


    people_in_front = user_number - current_number

    waiting_time = people_in_front * average_duration

    predicted_time = datetime.now() + timedelta(minutes=waiting_time)
    '''

    return jsonify({
        'user_number': '5',
        'predicted_waiting_time': prediction,
        'current_time': '8'
    })
    

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
