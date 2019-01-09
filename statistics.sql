SET STATISTICS io ON

SELECT *
FROM Booking b JOIN BookingOrder bo ON bo.BookingId = b.Id
WHERE b.Id = 5