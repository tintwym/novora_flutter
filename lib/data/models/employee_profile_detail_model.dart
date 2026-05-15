/// Rich employee profile payload for the HR profile UI (mock until API exists).
class EmployeeProfileDetailModel {
  const EmployeeProfileDetailModel({
    required this.header,
    required this.summary,
    required this.personal,
    required this.family,
    required this.biometric,
    required this.payRate,
    required this.career,
    required this.education,
    required this.documents,
  });

  final ProfileHeader header;
  final ProfileSummary summary;
  final ProfilePersonal personal;
  final ProfileFamily family;
  final ProfileBiometric biometric;
  final ProfilePayRate payRate;
  final ProfileCareer career;
  final ProfileEducation education;
  final ProfileDocuments documents;

  /// Design reference: Sarah Lim — Employee Directory mockups.
  static EmployeeProfileDetailModel mockDefault() => const EmployeeProfileDetailModel(
        header: ProfileHeader(
          fullName: 'Sarah Lim Wei Ling',
          initials: 'SL',
          statusLabel: 'Active',
          employeeCode: 'EMP-0021',
          location: 'Kuala Lumpur, HQ',
          departmentTitle: 'Engineering · Senior Developer',
          reportsTo: 'David Ng',
          tenureLabel: '4y 3m',
          payGradeLabel: 'G-7',
          leaveLeftLabel: '12',
          performanceLabel: '92%',
        ),
        summary: ProfileSummary(
          employment: [
            MapEntry('Employee No.', 'EMP-0021'),
            MapEntry('Company', 'AperioOccasio Sdn Bhd'),
            MapEntry('Department', 'Engineering'),
            MapEntry('Position', 'Senior Developer'),
            MapEntry('Job Type', 'Permanent'),
            MapEntry('Employment status', 'Active'),
            MapEntry('Join date', '12 Jan 2021'),
            MapEntry('Position start date', '1 Mar 2022'),
            MapEntry('Job grade', 'G-7 / Sub B'),
          ],
          leaveBalances: [
            LeaveBalanceRow(label: 'Annual leave', used: 12, total: 16, colorKey: 'blue'),
            LeaveBalanceRow(label: 'Medical leave', used: 10, total: 14, colorKey: 'green'),
            LeaveBalanceRow(label: 'Emergency leave', used: 2, total: 3, colorKey: 'orange'),
          ],
          performanceSkills: [
            PerformanceSkillRow(label: 'Technical skills', percent: 92, colorKey: 'blue'),
            PerformanceSkillRow(label: 'Communication', percent: 85, colorKey: 'blue'),
            PerformanceSkillRow(label: 'Teamwork', percent: 88, colorKey: 'blue'),
            PerformanceSkillRow(label: 'Punctuality', percent: 95, colorKey: 'green'),
            PerformanceSkillRow(label: 'Leadership', percent: 78, colorKey: 'purple'),
          ],
          lastAppraisal: 'Dec 2024 — Grade A',
          nextReview: 'Dec 2025',
          hrNotes:
              'Strong technical contributor. Nominated for tech lead role in Q3 2025. No disciplinary records. Eligible for promotion review.',
          blacklisted: false,
          autoClockIn: false,
        ),
        personal: ProfilePersonal(
          fullName: 'Sarah Lim Wei Ling',
          dateOfBirth: '14 March 1991',
          gender: 'Female',
          nationality: 'Malaysian',
          nric: '910314-10-5678',
          religion: 'Buddhism',
          maritalStatus: 'Married',
          personalEmail: 'sarah.lim@gmail.com',
          mobile: '+60 12-345 6789',
          race: 'Chinese',
          passportEnabled: true,
          passportNo: 'A12345678',
          passportCountry: 'Malaysia',
          passportIssue: '10 Jan 2020',
          passportExpiry: '9 Jan 2030',
          addr1: '12, Jalan Setia Prima A U13/A',
          addr2: 'Setia Alam',
          city: 'Shah Alam',
          state: 'Selangor',
          postcode: '40170',
          country: 'Malaysia',
          sameAsPermanent: true,
        ),
        family: ProfileFamily(
          members: [
            FamilyMemberRow(
              name: 'Lim Kah Fatt',
              relationship: 'Spouse',
              dob: '12 Jun 1988',
              nric: '880612-10-1234',
              taxExempt: true,
              passport: 'N/A',
            ),
            FamilyMemberRow(
              name: 'Lim Zhi Xuan',
              relationship: 'Child',
              dob: '4 Feb 2018',
              nric: '180204-10-5555',
              taxExempt: true,
              passport: 'N/A',
            ),
            FamilyMemberRow(
              name: 'Lim Mei Hua',
              relationship: 'Mother',
              dob: '8 Sep 1962',
              nric: '620908-10-4321',
              taxExempt: false,
              passport: 'N/A',
            ),
          ],
          emergencyContacts: [
            EmergencyContactRow(
              name: 'Lim Kah Fatt',
              relationship: 'Spouse',
              phone: '+60 16-789 1234',
              address: 'Same as employee',
            ),
          ],
        ),
        biometric: ProfileBiometric(
          enabled: true,
          devices: [
            BiometricDeviceRow(
              taNumber: 'TA-00451',
              terminal: 'Main Lobby — Terminal 1',
              deviceType: 'Fingerprint',
              location: 'HQ Ground Floor',
              active: true,
            ),
            BiometricDeviceRow(
              taNumber: 'TA-00452',
              terminal: 'Level 3 — Terminal 2',
              deviceType: 'Face ID',
              location: 'Engineering Floor',
              active: true,
            ),
          ],
          autoClock: false,
          ignoreMissingSwipe: false,
          ignoreRotaDeduction: false,
          assignedShift: 'Standard — 9:00 AM to 6:00 PM',
        ),
        payRate: ProfilePayRate(
          payGrade: 'G-7 / Sub B',
          payType: 'Monthly',
          currency: 'MYR',
          basicSalary: '7,500.00',
          effectiveDate: '1 Mar 2024',
          bankMasked: 'Maybank ●●●● 4521',
          allowances: [
            PayLineRow(label: 'Transport allowance', amount: '300.00', frequency: 'Monthly', taxable: false, active: true),
            PayLineRow(label: 'Meal allowance', amount: '200.00', frequency: 'Monthly', taxable: false, active: true),
            PayLineRow(label: 'Phone allowance', amount: '150.00', frequency: 'Monthly', taxable: true, active: true),
          ],
          deductions: [
            PayLineRow(label: 'EPF (Employee)', amount: '825.00', frequency: 'Monthly', ref: '11%', active: true),
            PayLineRow(label: 'SOCSO', amount: '49.40', frequency: 'Monthly', ref: 'Statutory', active: true),
            PayLineRow(label: 'Income Tax (PCB)', amount: '620.00', frequency: 'Monthly', ref: 'Est.', active: true),
          ],
          estimatedNetMonthly: '6,655.60',
        ),
        career: ProfileCareer(
          rows: [
            CareerRow(
              company: 'Tech Solutions Sdn Bhd',
              position: 'Junior Developer',
              fromLabel: 'Jun 2013',
              toLabel: 'Dec 2016',
              reason: 'Career growth',
            ),
            CareerRow(
              company: 'Infineon Technologies',
              position: 'Software Engineer',
              fromLabel: 'Jan 2017',
              toLabel: 'Dec 2020',
              reason: 'Better opportunity',
            ),
          ],
        ),
        education: ProfileEducation(
          rows: [
            EducationRow(
              institution: 'Universiti Malaya',
              qualification: "Bachelor's Degree",
              field: 'Computer Science',
              year: '2013',
              gradeLabel: 'First Class',
            ),
          ],
        ),
        documents: ProfileDocuments(
          rows: [
            DocumentRow(name: 'Offer Letter', type: 'Contract', uploaded: '12 Jan 2021', expiry: '—'),
            DocumentRow(name: 'NRIC Copy', type: 'ID', uploaded: '12 Jan 2021', expiry: '—'),
            DocumentRow(name: 'Passport', type: 'ID', uploaded: '10 Jan 2020', expiry: '9 Jan 2030'),
          ],
        ),
      );
}

class ProfileHeader {
  const ProfileHeader({
    required this.fullName,
    required this.initials,
    required this.statusLabel,
    required this.employeeCode,
    required this.location,
    required this.departmentTitle,
    required this.reportsTo,
    required this.tenureLabel,
    required this.payGradeLabel,
    required this.leaveLeftLabel,
    required this.performanceLabel,
  });

  final String fullName;
  final String initials;
  final String statusLabel;
  final String employeeCode;
  final String location;
  final String departmentTitle;
  final String reportsTo;
  final String tenureLabel;
  final String payGradeLabel;
  final String leaveLeftLabel;
  final String performanceLabel;
}

class ProfileSummary {
  const ProfileSummary({
    required this.employment,
    required this.leaveBalances,
    required this.performanceSkills,
    required this.lastAppraisal,
    required this.nextReview,
    required this.hrNotes,
    required this.blacklisted,
    required this.autoClockIn,
  });

  final List<MapEntry<String, String>> employment;
  final List<LeaveBalanceRow> leaveBalances;
  final List<PerformanceSkillRow> performanceSkills;
  final String lastAppraisal;
  final String nextReview;
  final String hrNotes;
  final bool blacklisted;
  final bool autoClockIn;
}

class LeaveBalanceRow {
  const LeaveBalanceRow({
    required this.label,
    required this.used,
    required this.total,
    required this.colorKey,
  });

  final String label;
  final int used;
  final int total;
  final String colorKey;
}

class PerformanceSkillRow {
  const PerformanceSkillRow({required this.label, required this.percent, required this.colorKey});

  final String label;
  final int percent;
  final String colorKey;
}

class ProfilePersonal {
  const ProfilePersonal({
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.nationality,
    required this.nric,
    required this.religion,
    required this.maritalStatus,
    required this.personalEmail,
    required this.mobile,
    required this.race,
    required this.passportEnabled,
    required this.passportNo,
    required this.passportCountry,
    required this.passportIssue,
    required this.passportExpiry,
    required this.addr1,
    required this.addr2,
    required this.city,
    required this.state,
    required this.postcode,
    required this.country,
    required this.sameAsPermanent,
  });

  final String fullName;
  final String dateOfBirth;
  final String gender;
  final String nationality;
  final String nric;
  final String religion;
  final String maritalStatus;
  final String personalEmail;
  final String mobile;
  final String race;
  final bool passportEnabled;
  final String passportNo;
  final String passportCountry;
  final String passportIssue;
  final String passportExpiry;
  final String addr1;
  final String addr2;
  final String city;
  final String state;
  final String postcode;
  final String country;
  final bool sameAsPermanent;
}

class FamilyMemberRow {
  const FamilyMemberRow({
    required this.name,
    required this.relationship,
    required this.dob,
    required this.nric,
    required this.taxExempt,
    required this.passport,
  });

  final String name;
  final String relationship;
  final String dob;
  final String nric;
  final bool taxExempt;
  final String passport;
}

class EmergencyContactRow {
  const EmergencyContactRow({
    required this.name,
    required this.relationship,
    required this.phone,
    required this.address,
  });

  final String name;
  final String relationship;
  final String phone;
  final String address;
}

class ProfileFamily {
  const ProfileFamily({required this.members, required this.emergencyContacts});

  final List<FamilyMemberRow> members;
  final List<EmergencyContactRow> emergencyContacts;
}

class BiometricDeviceRow {
  const BiometricDeviceRow({
    required this.taNumber,
    required this.terminal,
    required this.deviceType,
    required this.location,
    required this.active,
  });

  final String taNumber;
  final String terminal;
  final String deviceType;
  final String location;
  final bool active;
}

class ProfileBiometric {
  const ProfileBiometric({
    required this.enabled,
    required this.devices,
    required this.autoClock,
    required this.ignoreMissingSwipe,
    required this.ignoreRotaDeduction,
    required this.assignedShift,
  });

  final bool enabled;
  final List<BiometricDeviceRow> devices;
  final bool autoClock;
  final bool ignoreMissingSwipe;
  final bool ignoreRotaDeduction;
  final String assignedShift;
}

class PayLineRow {
  const PayLineRow({
    required this.label,
    required this.amount,
    required this.frequency,
    this.taxable,
    this.ref,
    required this.active,
  });

  final String label;
  final String amount;
  final String frequency;
  final bool? taxable;
  final String? ref;
  final bool active;
}

class ProfilePayRate {
  const ProfilePayRate({
    required this.payGrade,
    required this.payType,
    required this.currency,
    required this.basicSalary,
    required this.effectiveDate,
    required this.bankMasked,
    required this.allowances,
    required this.deductions,
    required this.estimatedNetMonthly,
  });

  final String payGrade;
  final String payType;
  final String currency;
  final String basicSalary;
  final String effectiveDate;
  final String bankMasked;
  final List<PayLineRow> allowances;
  final List<PayLineRow> deductions;
  final String estimatedNetMonthly;
}

class CareerRow {
  const CareerRow({
    required this.company,
    required this.position,
    required this.fromLabel,
    required this.toLabel,
    required this.reason,
  });

  final String company;
  final String position;
  final String fromLabel;
  final String toLabel;
  final String reason;
}

class ProfileCareer {
  const ProfileCareer({required this.rows});

  final List<CareerRow> rows;
}

class EducationRow {
  const EducationRow({
    required this.institution,
    required this.qualification,
    required this.field,
    required this.year,
    required this.gradeLabel,
  });

  final String institution;
  final String qualification;
  final String field;
  final String year;
  final String gradeLabel;
}

class ProfileEducation {
  const ProfileEducation({required this.rows});

  final List<EducationRow> rows;
}

class DocumentRow {
  const DocumentRow({
    required this.name,
    required this.type,
    required this.uploaded,
    required this.expiry,
  });

  final String name;
  final String type;
  final String uploaded;
  final String expiry;
}

class ProfileDocuments {
  const ProfileDocuments({required this.rows});

  final List<DocumentRow> rows;
}
