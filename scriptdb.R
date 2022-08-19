db <- data.frame(Jour = c(ymd("2022-08-17")), Pris = "Oui")
save(db, file = "data/db.Rdata")


db[1, "Pris"] <- "Non"

