# NGO Management Flutter App

## **Overview**
The **NGO Management Flutter App** is designed to streamline operations for NGOs by managing donations, events, and finances. It provides separate interfaces for **Admins**, **Donors**, and **Volunteers** to handle specific responsibilities.

---

## **Features**
1. **Admin Role**:
   - Manage events and donations.
   - Generate reports for donations, finances, and events.

2. **Donor Role**:
   - Donate to specific causes or events.
   - View donation history and impact.

3. **Volunteer Role**:
   - Add, edit, and delete donation records.

4. **Core Functionalities**:
   - Real-time financial reporting.
   - Event and donation management.
   - Push notifications for updates.

---

## **Functional Requirements**

### **1. User Authentication**
- **Admin Login**:
  - Manage events and donations.
- **Donor Login**:
  - Register and track their donation history.
- **Volunteer Login**:
  - Manage donation records.

### **2. Donation Management**
- **Add Donation**:
  - Record monetary or in-kind donations.
  - Enable one-time or recurring donations.
- **Donation History**:
  - Allow donors to view their contributions and impact.
  - Volunteers and Admins can edit or delete records.
- **Donation Reports**:
  - Admins can generate financial reports for transparency.

### **3. Event Management**
- **Create and Manage Events**:
  - Admins can add, edit, or delete events.
- **Event Registration**:
  - Donors can register or donate for events.
- **Event Reporting**:
  - Generate reports showing funds raised, participants, and event success.

### **4. Notifications**
- **Push Notifications**:
  - Real-time updates for events, tasks, and donations using Firebase Cloud Messaging.

### **5. Financial Reporting**
- Generate comprehensive reports for donations, expenses, and balances.
- Export reports in formats like PDF or CSV.

### **6. Payment Integration**
- Secure Stripe/PayPal payment gateway for donations and event ticket purchases.

---

## **Project Structure**

### **Screens and Roles**

| **Screen Name**                 | **Admin**                          | **Donor**                  | **Volunteer**               | **Purpose**                                                                                          |
|----------------------------------|------------------------------------|----------------------------|-----------------------------|------------------------------------------------------------------------------------------------------|
| **Login Screen**                | Login as Admin.                   | Login to donate.           | Login to manage donations.  | Secure login for all users based on roles.                                                          |
| **Dashboard Screen**            | Overview of all modules.          | Summary of donations.      | Overview of donations.      | Role-based dashboard to provide quick insights.                                                     |
| **Add Donation Screen**         | Monitor donations.                | Add donations.             | Add donations.              | Admin tracks donations; Donor and Volunteer add funds for events or causes.                         |
| **Donation History Screen**     | Generate reports.                 | View past donations.       | Edit or delete records.     | Admin generates detailed reports; Donors view personal history; Volunteers manage donation records. |
| **Add Event Screen**            | Create, edit, and delete events.  | N/A                        | N/A                         | Admin can manage all events.                                                                        |
| **Event List Screen**           | Monitor registrations.            | Register for events.       | N/A                         | List of all upcoming and past events with participation details.                                     |
| **Reports Screen**              | Generate financial/event reports. | View donation impact.      | N/A                         | Generate insights for transparency and performance evaluation.                                       |
| **Notifications Screen**        | Manage all notifications.         | Receive alerts.            | Receive alerts.             | Notify users about new events, tasks, and donations.                                                |

---

## **Project Timeline**

| **Week** | **Tasks**                                                                                          | **Deliverables**                                              |
|----------|----------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| **1**    | Set up Flutter project, configure Firebase, implement authentication, and create navigation setup. | Authentication and navigation system.                        |
| **2**    | Develop donation management and event management modules.                                          | Functional donation and event management screens.            |
| **3**    | Add notification functionality and implement donation editing and deletion.                        | Fully functional donation features with notifications.       |
| **4**    | Test the app, refine UI/UX, finalize reporting modules, and deploy.                                | Fully tested app ready for deployment to app stores.         |

---

## **Technical Details**

### **Frontend**:
- **Framework**: Flutter (Dart)
- **Design**: Material Design for a clean, intuitive interface.

### **Backend**:
- **Firebase Firestore**: Real-time database management.
- **Firebase Authentication**: Secure login functionality.
- **Firebase Cloud Messaging**: Push notifications.
- **Stripe/PayPal**: Payment gateway integration.

### **State Management**:
- **Provider**: Efficient state management for scalable applications.

---

## **Roles and Functionality**

### **Admin**:
- Manage events and donations.
- Generate reports for stakeholders.

### **Donor**:
- Donate to events or causes via Stripe/PayPal.
- View donation history and impact reports.

### **Volunteer**:
- Add, edit, and delete donation records.

---

## **Installation**

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd ngo-management-app
   
