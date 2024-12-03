# NGO Management Flutter App

## **Overview**
The **NGO Management Flutter App** is designed to streamline operations for NGOs by managing donations, events, volunteers, and finances. It provides separate interfaces for **Admins**, **Donors**, and **Volunteers** to handle specific responsibilities.

---

## **Features**
1. **Admin Role**:
   - Manage events, donations, beneficiaries, and volunteers.
   - Generate reports for donations, finances, and events.

2. **Donor Role**:
   - Donate to specific causes or events.
   - View donation history and impact.

3. **Volunteer Role**:
   - View and perform assigned tasks.
   - Track progress on assigned activities.

4. **Core Functionalities**:
   - Real-time financial reporting.
   - Event and task management.
   - Push notifications for updates.

---

## **Project Structure**

### **Screens and Roles**

| **Screen Name**                 | **Admin**                          | **Donor**                  | **Volunteer**               | **Purpose**                                                                                          |
|----------------------------------|------------------------------------|----------------------------|-----------------------------|------------------------------------------------------------------------------------------------------|
| **Login Screen**                | Login as Admin.                   | Login to donate.           | Login to view tasks.        | Secure login for all users based on roles.                                                          |
| **Dashboard Screen**            | Overview of all modules.          | Summary of donations.      | Overview of tasks.          | Role-based dashboard to provide quick insights.                                                     |
| **Add Donation Screen**         | Monitor donations.                | Add donations.             | N/A                         | Admin tracks donations; Donor adds funds for events or causes.                                      |
| **Donation History Screen**     | Generate reports.                 | View past donations.       | N/A                         | Admin generates detailed reports; Donors view personal history.                                     |
| **Add Event Screen**            | Create, edit, and delete events.  | N/A                        | N/A                         | Admin can manage all events.                                                                        |
| **Event List Screen**           | Monitor registrations.            | Register for events.       | Sign up for tasks.          | List of all upcoming and past events with participation details.                                     |
| **Volunteer Management Screen** | Assign tasks to volunteers.       | N/A                        | View assigned tasks.        | Admin assigns tasks; Volunteers track progress.                                                     |
| **Beneficiary List Screen**     | Track aid distributed.            | N/A                        | N/A                         | Admin manages beneficiary profiles and assistance records.                                           |
| **Reports Screen**              | Generate financial/event reports. | View donation impact.      | View activity progress.     | Generate insights for transparency and performance evaluation.                                       |
| **Notifications Screen**        | Manage all notifications.         | Receive alerts.            | Receive alerts.             | Notify users about new events, tasks, and donations.                                                |

---

## **Project Timeline**

| **Week** | **Tasks**                                                                                          | **Deliverables**                                              |
|----------|----------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| **1**    | Set up Flutter project, configure Firebase, implement authentication, and create navigation setup. | Authentication and navigation system.                        |
| **2**    | Develop donation management and event management modules.                                          | Functional donation and event management screens.            |
| **3**    | Build volunteer management and beneficiary management modules.                                     | Volunteer and beneficiary features with notification setup.  |
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
- Manage all system modules (donations, events, beneficiaries, volunteers).
- Assign volunteer tasks and monitor progress.
- Generate reports for stakeholders.

### **Donor**:
- Donate to events or causes via Stripe/PayPal.
- View donation history and impact reports.

### **Volunteer**:
- View assigned tasks and update progress.
- Participate in events by signing up for activities.

---

## **Installation**

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd ngo-management-app
   
