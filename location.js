// This function calculates the distance between two points based on the latitude and longitude coordinates in kilometers 
function calculateDistance(lat1, lon1, lat2, lon2) {
               // Approximate Radius of earth (in km) 
               R = 6371;
               // Converting latitudes and longitudes from radians to degrees
               let dLat = deg2rad(lat2 - lat1);
               let dLon = deg2rad(lon2 - lon1);
               // Using Haversine Formula 
               let a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
               let c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
               let d = R * c;
               return d;
}

// This function converts degrees to radians 
function deg2rad(deg) {
               return deg * (Math.PI / 180)
}