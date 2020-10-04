//API Key
const GoogleApiKey = "AIzaSyCSdJNFravZ9yjzisUAhLgohy_MWbS41XI";
const autoCompleteLink =
    "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=$GoogleApiKey&components=country:in&types=(cities)&input=";

//Basic Pages
const String splashPage = "/";
const String truckOwnerUser = "TruckOwner";
const String transporterUser = "Transporter";
const String driverUser = "Driver";

//Login or SignUp Pages
const String introLoginOptionPage = "/introLoginPage";
const String driverOptionPage = "/driverOptionPage";
const String transporterOptionPage = "/transporterOptionPage";
const String ownerOptionPage = "/ownerOptionPage";

//Pages which don't need LoggedIn User
const String emiCalculatorPage = "/emiCalculatorPage";
const String freightCalculatorPage = "/freightCalculatorPage";
const String tollCalculatorPage = "/tollCalculatorPage";
const String tripPlannerPage = "/tripPlannerPage";

//Pages once the user is LoggedIn - Driver
const String homePageDriver = "/homePageDriver";
const String driverUpcomingOrderPage = "/driverUpcomingOrderPage";
const String driverDocsUploadPage = "/driverDocs";
const String deliveriesPage = '/myDel';
