#!/bin/bash
WRITEDATE=$(date +%Y-%m-%d)
if [ $# -le 2 ]; then
echo "Usage: ./script VenueCode Premium/Standard /path/to/barcode.csv" 
echo "Example: ./barcode.sh WK PREMIUM /opt/barcode/bc.csv"
exit 0
fi
if [[ ${2,,} = *s* ]]; then
price=45.00
else
price=65.00
fi
sed 's/,//g' $3 > $1-$2-$WRITEDATE-plain-barcodes\.csv
echo "Venue (WK or SP): $1"
echo "Premium or Standard codes? (P/S): $2"
echo "Path to original barcode: $3"
echo "Reading barcodes"
sleep 10
#let sed do its thing
while read L; do
  echo "('$L', '$1 $2 code', 0.00, $price, 1374077422, 1735929001, 1, 0, 0.00, 1, 0)," >> $1-$2-$WRITEDATE-Full-CSV\.csv
done <$1-$2-$WRITEDATE-plain-barcodes\.csv
echo "insert into DB_NAME.coupons (coupon, description, percent, dollar, date_add, date_end, max_redemptions, redemptions, min_order, free_shipping, min_qty)

values" > base-query.txt
cat base-query.txt $1-$2-$WRITEDATE-Full-CSV\.csv > $1-$2-SQL-Query.txt
echo "SQL Query Generated: $1-$2-SQL-Query.txt"
