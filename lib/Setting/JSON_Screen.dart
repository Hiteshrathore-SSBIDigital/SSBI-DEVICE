loadJsonData() {
  return '''
      {
        "department": [
          {
            "Meghalaya": ["Department of Business Development"],
            "Arunachal Pradesh": ["Department of Business Development", "Department of Livelihood and Entrepreneurship"],
            "Assam": ["Department of Business Development", "Department of Livelihood and Entrepreneurship"],
            "Manipur": ["Department of Advocacy, Consultancy & Projects"],
            "Mizoram": ["Department of Business Development"],
            "Nagaland": ["Department of Business Development"],
            "Tripura": ["Department of Advocacy, Consultancy & Projects"]
          }
        ],
        "states": [
          {
            "name": "Meghalaya",
            "districts": ["North Garo Hills", "Ri Bhoi"]
          },
          {
            "name": "Arunachal Pradesh",
            "districts": ["Anjaw", "East Kameng", "East Siang", "Lohit", "Papum Pare", "Tirap", "West Kameng"]
          },
          {
            "name": "Assam",
            "districts": ["Baksa", "Barpeta", "Biswanath", "Bongaigaon", "Chirang", "Darrang", "Dhemaji", "Dhubri", "Dibrugarh", "Jorhat", "Kamrup", "Kamrup Metropolitan", "Karbi Anglong", "Kokrajhar", "Lakhimpur", "Nalbari", "Sivasagar", "Tamulpura", "Tinsukia", "Udalguri"]
          },
          {
            "name": "Manipur",
            "districts": ["Bishnupur", "Imphal East", "Imphal West", "Senapati", "Thoubal"]
          },
          {
            "name": "Mizoram",
            "districts": ["Aizawl", "Champhai", "Lunglei", "Serchhip"]
          },
          {
            "name": "Nagaland",
            "districts": ["Dimapur", "Phek", "Wokha"]
          },
          {
            "name": "Tripura",
            "districts": ["Dhalai", "North Tripura", "South Tripura", "West Tripura"]
          }
        ]
      }
    ''';
}
