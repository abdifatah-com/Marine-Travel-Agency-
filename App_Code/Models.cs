using System;

namespace MarineTravelAgency.App_Code
{
    public class User
    {
        public int UserId { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PhoneNumber { get; set; }
        public string Role { get; set; }
    }

    public class Trip
    {
        public int TripId { get; set; }
        public int DestinationId { get; set; }
        public string ShipName { get; set; }
        public DateTime DepartureDate { get; set; }
        public DateTime ReturnDate { get; set; }
        public decimal PricePerPerson { get; set; }
        public int MaxCapacity { get; set; }
        public int AvailableSeats { get; set; }
        public string Status { get; set; }
    }

    public class Booking
    {
        public int BookingId { get; set; }
        public int TripId { get; set; }
        public string CustomerName { get; set; }
        public string CustomerEmail { get; set; }
        public int NumberOfGuests { get; set; }
        public decimal TotalAmount { get; set; }
        public DateTime BookingDate { get; set; }
    }
}
