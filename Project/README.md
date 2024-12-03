
---

# NGO Management Flutter App

## **Overview**
The **NGO Management Flutter App** streamlines the operations of NGOs by providing a platform to manage donations, events, volunteers, beneficiaries, and finances. This app ensures transparency and effective engagement with donors and stakeholders.

---

## **Features**
1. **Authentication**:
   - Secure login for Admins, Donors, and Volunteers.
   - Firebase Authentication integration.

2. **Donation Management**:
   - Add donations (money, goods, services).
   - Track donation history and generate financial reports.

3. **Event Management**:
   - Plan and manage events.
   - Allow users to register, donate, and buy tickets.

4. **Volunteer Management**:
   - Volunteer sign-ups and task assignments.
   - Monitor progress and generate volunteer reports.

5. **Beneficiary Management**:
   - Manage profiles of beneficiaries.
   - Track aid distribution and generate reports.

6. **Push Notifications**:
   - Notify users about events, donations, and updates using Firebase Cloud Messaging.

---

## **Project Structure**

### **Screens**

#### **1. Authentication Screens**
- **Login Screen**:
  - Functionality:
    - Email/password login for Admin, Donor, and Volunteer.
    - Role-based redirection to respective dashboards.
  - Firebase Authentication integration.
- **Registration Screen**:
  - Functionality:
    - New users can sign up (Donors, Volunteers).
    - Validation for email and password inputs.
- **Forgot Password Screen**:
  - Functionality:
    - Allow users to reset their password via email.

---

#### **2. Dashboard Screens**
- **Admin Dashboard**:
  - Overview of donations, events, volunteers, and beneficiaries.
  - Metrics on funds raised and resources distributed.
- **Donor Dashboard**:
  - Summary of donations and event participation.
  - Access donation history.
- **Volunteer Dashboard**:
  - View assigned tasks and completed hours.

---

#### **3. Donation Management Screens**
- **Add Donation Screen**:
  - Functionality:
    - Donors can record monetary or in-kind donations.
    - Payment gateway integration (Stripe/PayPal).
- **Donation History Screen**:
  - Functionality:
    - View past donations with filters (date, event).
- **Financial Reports Screen**:
  - Functionality:
    - Generate and export donation reports in PDF/CSV format.

---

#### **4. Event Management Screens**
- **Event List Screen**:
  - Functionality:
    - Display upcoming and past events.
    - Filter events by date or type.
- **Event Details Screen**:
  - Functionality:
    - View event details, register, or donate.
- **Event Management Screen (Admin)**:
  - Functionality:
    - Admins can create, edit, and delete events.
    - Track event registration and ticket sales.

---

#### **5. Volunteer Management Screens**
- **Volunteer Registration Screen**:
  - Functionality:
    - Volunteers can sign up with skills and availability.
- **Task Assignment Screen (Admin)**:
  - Functionality:
    - Assign tasks to volunteers and monitor their progress.
- **Volunteer Progress Screen**:
  - Functionality:
    - Track volunteer hours and task completions.

---

#### **6. Beneficiary Management Screens**
- **Beneficiary List Screen**:
  - Functionality:
    - Display a list of beneficiaries with filtering options.
- **Beneficiary Profile Screen**:
  - Functionality:
    - View details of a beneficiary and aid received.
- **Assistance Tracking Screen**:
  - Functionality:
    - Admins can track the type and amount of aid given.

---

#### **7. Notifications**
- **Push Notifications**:
  - Firebase Cloud Messaging integration.
  - Notify users about events, updates, and donation statuses.
- **In-App Notifications**:
  - Real-time updates on tasks, events, or donations.

---

#### **8. Settings Screen**
- **User Profile Management**:
  - Functionality:
    - Update user details and preferences.
- **App Settings**:
  - Functionality:
    - Toggle notifications and adjust app preferences.

---

## **Project Timeline**

| **Week** | **Tasks**                                                                                                   | **Deliverables**                                              |
|----------|-----------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| **1**    | Set up project, configure Firebase, implement authentication, and create dashboards.                       | Authentication screens and navigation system.                |
| **2**    | Develop donation and event management screens.                                                             | Donation and Event screens with payment integration.         |
| **3**    | Build volunteer and beneficiary management modules and set up push notifications.                          | Volunteer, Beneficiary, and Notification features.           |
| **4**    | Test the app, polish UI/UX, finalize report generation, and deploy the app to app stores.                  | Fully tested and polished app ready for deployment.          |

---

## **Technical Details**

### **Frontend**:
- **Framework**: Flutter (Dart)
- **Design**: Material Design principles for a clean, intuitive interface.

### **Backend**:
- **Firebase Firestore**: Real-time database management.
- **Firebase Authentication**: Secure login functionality.
- **Firebase Cloud Messaging**: Push notifications.
- **Stripe/PayPal**: Payment gateway integration.

### **State Management**:
- **Provider**: Efficient state management for scalable applications.

---

## **Installation**

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd ngo-management-app

2. Install dependencies:

flutter pub get


3. Run the app:

flutter run


4. Set up Firebase:

Add google-services.json (Android) and GoogleService-Info.plist (iOS) files to the project.





---

Milestones


---

Deliverables

Fully functioning NGO Management Flutter App.

Complete source code, Firebase configurations, and documentation.

Deployment-ready app for both Android and iOS.


Let me know if you'd like further assistance!

