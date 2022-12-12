//
//  Endpoints.swift
//  IamHere
//
//  Created by Imran Rasheed on 09/09/2022.
//

import Foundation
struct Endpoint {
    static let shared = Endpoint()
    
    var loginUrl = "/users/login"
    var registerUrl = "/users/register"
    var categories = "/categories/get_categories"
    var get_coaches_home = "/coaches/get_coaches/"
    var getCoacheAvailbilityDays = "/coaches/get_availability_days"
    var profilePhoto = "/users/profilePhoto"
    var getCoacheAvailbilityHours = "/coaches/get_availability_hours/"
    var get_journals = "/journals/get_journals/"
    var add_journals = "/journals/add_journals"
    var get_affirmations = "/affirmations/get_affrimations_types"
    var get_books_home = "/books/get_books_home"
    var get_books = "/books/get_books"
    var get_randomJournal = "/journals/get_randomJournal"
    var get_affirmation = "/affirmations/get_affrimations/"
    var bookAppointment = "/users/book_appointment"
    var journalById = "/journals/get_journal_by_id/"
    var updateJournal = "/journals/update_journals/"
    var getAllInboxes = "/message/get_user_all_inobexs"
    var getMessages = "/message/get_user_messages/"
    var appointments = "/users/appointments/"
    var cancelAppointments = "/users/cancel_appointments/"
    var reScheduleAppointment = "/users/reSchedule_appointments/"
    var updateProfile = "/users/updateProfile"
    var sendMessage = "/message/send_message"
}
