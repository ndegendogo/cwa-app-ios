////
// 🦠 Corona-Warn-App
//

import XCTest
import FMDB
import Combine
@testable import ENA

// swiftlint:disable:next type_body_length
class ContactDiaryStoreV1Tests: XCTestCase {

	private var subscriptions = [AnyCancellable]()

	func test_When_addContactPerson_Then_ContactPersonIsPersisted() {
		let databaseQueue = makeDatabaseQueue()
		let store = makeContactDiaryStore(with: databaseQueue)

		let result = store.addContactPerson(name: "Helge Schneider")

		if case let .failure(error) = result {
			XCTFail("Error not expected: \(error)")
		}

		guard case let .success(id) = result,
			  let contactPerson = fetchEntries(for: "ContactPerson", with: id, from: databaseQueue),
			  let name = contactPerson.string(forColumn: "name") else {
			XCTFail("Failed to fetch ContactPerson")
			return
		}

		XCTAssertEqual(name, "Helge Schneider")
	}

	func test_When_addLocation_Then_LocationIsPersisted() {
		let databaseQueue = makeDatabaseQueue()
		let store = makeContactDiaryStore(with: databaseQueue)

		let result = store.addLocation(name: "Hinterm Mond")

		if case let .failure(error) = result {
			XCTFail("Error not expected: \(error)")
		}

		guard case let .success(id) = result,
			  let location = fetchEntries(for: "Location", with: id, from: databaseQueue),
			  let name = location.string(forColumn: "name") else {
			XCTFail("Failed to fetch ContactPerson")
			return
		}

		XCTAssertEqual(name, "Hinterm Mond")
	}

	func test_When_addContactPersonEncounter_Then_ContactPersonEncounterIsPersisted() {
		let databaseQueue = makeDatabaseQueue()
		let store = makeContactDiaryStore(with: databaseQueue)

		let addPersonResult = store.addContactPerson(name: "Helge Schneider")

		guard case let .success(contactPersonId) = addPersonResult else {
			XCTFail("Failed to add ContactPerson")
			return
		}

		let result = store.addContactPersonEncounter(contactPersonId: contactPersonId, date: "2020-12-10")

		if case let .failure(error) = result {
			XCTFail("Error not expected: \(error)")
		}

		guard case let .success(id) = result,
			  let contactPersonEncounter = fetchEntries(for: "ContactPersonEncounter", with: id, from: databaseQueue),
			  let date = contactPersonEncounter.string(forColumn: "date") else {
			XCTFail("Failed to fetch ContactPerson")
			return
		}

		let fetchedContactPersonId = Int(contactPersonEncounter.int(forColumn: "contactPersonId"))

		XCTAssertEqual(date, "2020-12-10")
		XCTAssertEqual(fetchedContactPersonId, contactPersonId)
	}

	func test_When_addLocationVisit_Then_LocationVisitIsPersisted() {
		let databaseQueue = makeDatabaseQueue()
		let store = makeContactDiaryStore(with: databaseQueue)

		let addLocationResult = store.addLocation(name: "Nirgendwo")

		guard case let .success(locationId) = addLocationResult else {
			XCTFail("Failed to add Location")
			return
		}

		let result = store.addLocationVisit(locationId: locationId, date: "2020-12-10")

		if case let .failure(error) = result {
			XCTFail("Error not expected: \(error)")
		}

		guard case let .success(id) = result,
			  let locationVisit = fetchEntries(for: "LocationVisit", with: id, from: databaseQueue),
			  let date = locationVisit.string(forColumn: "date") else {
			XCTFail("Failed to fetch ContactPerson")
			return
		}

		let fetchedLocationId = Int(locationVisit.int(forColumn: "locationId"))

		XCTAssertEqual(date, "2020-12-10")
		XCTAssertEqual(fetchedLocationId, locationId)
	}

	func test_When_updateContactPerson_Then_ContactPersonIsUpdated() {
		let databaseQueue = makeDatabaseQueue()
		let store = makeContactDiaryStore(with: databaseQueue)

		let result = store.addContactPerson(name: "Helge Schneider")

		guard case let .success(id) = result else {
			XCTFail("Failed to add ContactPerson")
			return
		}

		let updateResult = store.updateContactPerson(id: id, name: "Updated Name")

		guard case .success = updateResult else {
			XCTFail("Failed to update ContactPerson")
			return
		}

		guard let contactPerson = fetchEntries(for: "ContactPerson", with: id, from: databaseQueue),
			  let name = contactPerson.string(forColumn: "name") else {
			XCTFail("Failed to fetch ContactPerson")
			return
		}

		XCTAssertEqual(name, "Updated Name")
	}

	func test_When_updateLocation_Then_LocationIsUpdated() {
		let databaseQueue = makeDatabaseQueue()
		let store = makeContactDiaryStore(with: databaseQueue)

		let result = store.addLocation(name: "Woanders")

		guard case let .success(id) = result else {
			XCTFail("Failed to add Location")
			return
		}

		let updateResult = store.updateLocation(id: id, name: "Updated Name")

		guard case .success = updateResult else {
			XCTFail("Failed to update Location")
			return
		}

		guard let location = fetchEntries(for: "Location", with: id, from: databaseQueue),
			  let name = location.string(forColumn: "name") else {
			XCTFail("Failed to fetch ContactPerson")
			return
		}

		XCTAssertEqual(name, "Updated Name")
	}

	func test_When_removeContactPerson_Then_ContactPersonAndEncountersAreDeleted() {
		let databaseQueue = makeDatabaseQueue()
		let store = makeContactDiaryStore(with: databaseQueue)

		let addContactPersonResult = store.addContactPerson(name: "Helge Schneider")
		guard case let .success(contactPersonId) = addContactPersonResult else {
			XCTFail("Failed to add ContactPerson")
			return
		}

		let addEncounterResult = store.addContactPersonEncounter(contactPersonId: contactPersonId, date: "2020-12-10")
		guard case let .success(encounterId) = addEncounterResult else {
			XCTFail("Failed to add ContactPersonEncounter")
			return
		}

		let removeResult = store.removeContactPerson(id: contactPersonId)
		if case let .failure(error) = removeResult {
			XCTFail("Error not expected: \(error)")
		}

		let fetchPersonResult = fetchEntries(for: "ContactPerson", with: contactPersonId, from: databaseQueue)
		XCTAssertNil(fetchPersonResult)

		let fetchEncounterResult = fetchEntries(for: "ContactPersonEncounter", with: encounterId, from: databaseQueue)
		XCTAssertNil(fetchEncounterResult)
	}

	func test_When_removeLocation_Then_LocationAndLocationVisitsAreDeleted() {
		let databaseQueue = makeDatabaseQueue()
		let store = makeContactDiaryStore(with: databaseQueue)

		let addLocationResult = store.addLocation(name: "Nicht hier")
		guard case let .success(locationId) = addLocationResult else {
			XCTFail("Failed to add Location")
			return
		}

		let addLocationVisitResult = store.addLocationVisit(locationId: locationId, date: "2020-12-10")
		guard case let .success(locationVisitId) = addLocationVisitResult else {
			XCTFail("Failed to add LocationVisit")
			return
		}

		let removeResult = store.removeLocation(id: locationId)
		if case let .failure(error) = removeResult {
			XCTFail("Error not expected: \(error)")
		}

		let fetchLocationResult = fetchEntries(for: "Location", with: locationId, from: databaseQueue)
		XCTAssertNil(fetchLocationResult)

		let fetchLocationVisitResult = fetchEntries(for: "LocationVisit", with: locationVisitId, from: databaseQueue)
		XCTAssertNil(fetchLocationVisitResult)
	}

	func test_When_removeContactPersonEncounter_Then_ContactPersonEncounterIsDeleted() {
		let databaseQueue = makeDatabaseQueue()
		let store = makeContactDiaryStore(with: databaseQueue)

		let addContactPersonResult = store.addContactPerson(name: "Helge Schneider")
		guard case let .success(contactPersonId) = addContactPersonResult else {
			XCTFail("Failed to add ContactPerson")
			return
		}

		let addEncounterResult = store.addContactPersonEncounter(contactPersonId: contactPersonId, date: "2020-12-10")
		guard case let .success(encounterId) = addEncounterResult else {
			XCTFail("Failed to add ContactPersonEncounter")
			return
		}

		let encounterResultBeforeDelete = fetchEntries(for: "ContactPersonEncounter", with: encounterId, from: databaseQueue)
		XCTAssertNotNil(encounterResultBeforeDelete)

		let removeEncounterResult = store.removeContactPersonEncounter(id: encounterId)
		if case let .failure(error) = removeEncounterResult {
			XCTFail("Error not expected: \(error)")
		}

		let encounterResultAfterDelete = fetchEntries(for: "ContactPersonEncounter", with: encounterId, from: databaseQueue)
		XCTAssertNil(encounterResultAfterDelete)
	}

	func test_When_removeLocationVisit_Then_LocationVisitIsDeleted() {
		let databaseQueue = makeDatabaseQueue()
		let store = makeContactDiaryStore(with: databaseQueue)

		let addLocationResult = store.addLocation(name: "Nicht hier")
		guard case let .success(locationId) = addLocationResult else {
			XCTFail("Failed to add Location")
			return
		}

		let addLocationVisitResult = store.addLocationVisit(locationId: locationId, date: "2020-12-10")
		guard case let .success(locationVisitId) = addLocationVisitResult else {
			XCTFail("Failed to add LocationVisit")
			return
		}

		let fetchLocationVisitResult1 = fetchEntries(for: "LocationVisit", with: locationVisitId, from: databaseQueue)
		XCTAssertNotNil(fetchLocationVisitResult1)

		let removeEncounterResult = store.removeLocationVisit(id: locationVisitId)
		if case let .failure(error) = removeEncounterResult {
			XCTFail("Error not expected: \(error)")
		}

		let fetchLocationVisitResult2 = fetchEntries(for: "LocationVisit", with: locationVisitId, from: databaseQueue)
		XCTAssertNil(fetchLocationVisitResult2)
	}

	func test_When_removeAllContactPersons_Then_AllContactPersonsAreDeleted() {
		let databaseQueue = makeDatabaseQueue()
		let store = makeContactDiaryStore(with: databaseQueue)

		let addContactPerson1Result = store.addContactPerson(name: "Some Person")
		guard case let .success(contactPerson1Id) = addContactPerson1Result else {
			XCTFail("Failed to add ContactPerson")
			return
		}

		let addContactPerson2Result = store.addContactPerson(name: "Other Person")
		guard case let .success(contactPerson2Id) = addContactPerson2Result else {
			XCTFail("Failed to add ContactPerson")
			return
		}

		let fetchPerson1ResultBeforeDelete = fetchEntries(for: "ContactPerson", with: contactPerson1Id, from: databaseQueue)
		XCTAssertNotNil(fetchPerson1ResultBeforeDelete)
		let fetchPerson2ResultBeforeDelete = fetchEntries(for: "ContactPerson", with: contactPerson2Id, from: databaseQueue)
		XCTAssertNotNil(fetchPerson2ResultBeforeDelete)

		let removeResult = store.removeAllContactPersons()
		if case let .failure(error) = removeResult {
			XCTFail("Error not expected: \(error)")
		}

		let fetchPerson1ResultAfterDelete = fetchEntries(for: "ContactPerson", with: contactPerson1Id, from: databaseQueue)
		XCTAssertNil(fetchPerson1ResultAfterDelete)
		let fetchPerson2ResultAfterDelete = fetchEntries(for: "ContactPerson", with: contactPerson2Id, from: databaseQueue)
		XCTAssertNil(fetchPerson2ResultAfterDelete)
	}

	func test_When_sinkOnDiaryDays_Then_diaryDaysAreReturned() {
		let databaseQueue = makeDatabaseQueue()
		let store = makeContactDiaryStore(with: databaseQueue)

		let today = Date()

		guard let tenDaysAgo = Calendar.current.date(byAdding: .day, value: -10, to: today),
			  let sixteenDaysAgo = Calendar.current.date(byAdding: .day, value: -16, to: today),
			  let seventeenDaysAgo = Calendar.current.date(byAdding: .day, value: -17, to: today) else {
			fatalError("Could not create test dates.")
		}

		let emmaHicksPersonId = addContactPerson(name: "Emma Hicks", to: store)
		let maryBarryPersonId = addContactPerson(name: "Mary Barry", to: store)

		let conistonLocationId = addLocation(name: "Coniston", to: store)
		let kincardineLocationId = addLocation(name: "Kincardine", to: store)

		// Today
		addLocationVisit(locationId: conistonLocationId, date: today, store: store)
		addLocationVisit(locationId: kincardineLocationId, date: today, store: store)
		addPersonEncounter(personId: emmaHicksPersonId, date: today, store: store)

		// 10 days ago
		addLocationVisit(locationId: kincardineLocationId, date: tenDaysAgo, store: store)
		addPersonEncounter(personId: maryBarryPersonId, date: tenDaysAgo, store: store)

		// 16 days ago (should not be persisted)
		addPersonEncounter(personId: maryBarryPersonId, date: sixteenDaysAgo, store: store)
		addPersonEncounter(personId: emmaHicksPersonId, date: sixteenDaysAgo, store: store)

		// 17 days ago (should not be persisted)
		addLocationVisit(locationId: kincardineLocationId, date: seventeenDaysAgo, store: store)
		addLocationVisit(locationId: conistonLocationId, date: seventeenDaysAgo, store: store)

		store.diaryDaysPublisher.sink { diaryDays in
			// Only the last 16 days + today should be returned.
			XCTAssertEqual(diaryDays.count, 17)

			for diaryDay in diaryDays {
				XCTAssertEqual(diaryDay.entries.count, 4)
			}

			// Test the data for today
			let todayDiaryDay = diaryDays[0]

			self.checkPersonEntry(entry: todayDiaryDay.entries[0], name: "Emma Hicks", id: emmaHicksPersonId, isSelected: true)
			self.checkPersonEntry(entry: todayDiaryDay.entries[1], name: "Mary Barry", id: maryBarryPersonId, isSelected: false)

			self.checkLocationEntry(entry: todayDiaryDay.entries[2], name: "Coniston", id: conistonLocationId, isSelected: true)
			self.checkLocationEntry(entry: todayDiaryDay.entries[3], name: "Kincardine", id: kincardineLocationId, isSelected: true)

			// Test the data for ten days ago
			let tenDaysAgoDiaryDay = diaryDays[10]

			self.checkPersonEntry(entry: tenDaysAgoDiaryDay.entries[0], name: "Emma Hicks", id: emmaHicksPersonId, isSelected: false)
			self.checkPersonEntry(entry: tenDaysAgoDiaryDay.entries[1], name: "Mary Barry", id: maryBarryPersonId, isSelected: true)

			self.checkLocationEntry(entry: tenDaysAgoDiaryDay.entries[2], name: "Coniston", id: conistonLocationId, isSelected: false)
			self.checkLocationEntry(entry: tenDaysAgoDiaryDay.entries[3], name: "Kincardine", id: kincardineLocationId, isSelected: true)

			// Test the data for sixteen days ago
			let sixteenDaysAgoDiaryDay = diaryDays[16]
			self.checkPersonEntry(entry: sixteenDaysAgoDiaryDay.entries[0], name: "Emma Hicks", id: emmaHicksPersonId, isSelected: true)
			self.checkPersonEntry(entry: sixteenDaysAgoDiaryDay.entries[1], name: "Mary Barry", id: maryBarryPersonId, isSelected: true)

			self.checkLocationEntry(entry: sixteenDaysAgoDiaryDay.entries[2], name: "Coniston", id: conistonLocationId, isSelected: false)
			self.checkLocationEntry(entry: sixteenDaysAgoDiaryDay.entries[3], name: "Kincardine", id: kincardineLocationId, isSelected: false)

		}.store(in: &subscriptions)
	}

	func test_When_cleanupIsCalled_Then_EntriesOlderThen16DaysAreDeleted() {
		let databaseQueue = makeDatabaseQueue()
		let store = makeContactDiaryStore(with: databaseQueue)

		let today = Date()

		guard let seventeenDaysAgo = Calendar.current.date(byAdding: .day, value: -17, to: today) else {
			fatalError("Could not create test dates.")
		}

		let emmaHicksPersonId = addContactPerson(name: "Emma Hicks", to: store)
		let kincardineLocationId = addLocation(name: "Kincardine", to: store)

		let personEncounterId = addPersonEncounter(personId: emmaHicksPersonId, date: seventeenDaysAgo, store: store)
		let locationVisitId = addLocationVisit(locationId: kincardineLocationId, date: seventeenDaysAgo, store: store)

		let personEncouterBeforeCleanupResult = fetchEntries(for: "ContactPersonEncounter", with: personEncounterId, from: databaseQueue)
		XCTAssertNotNil(personEncouterBeforeCleanupResult)

		let locationVisitBeforeCleanupResult = fetchEntries(for: "LocationVisit", with: locationVisitId, from: databaseQueue)
		XCTAssertNotNil(locationVisitBeforeCleanupResult)

		let cleanupResult = store.cleanup()
		guard case .success = cleanupResult else {
			fatalError("Failed to cleanup store.")
		}

		let personEncouterResult = fetchEntries(for: "ContactPersonEncounter", with: personEncounterId, from: databaseQueue)
		XCTAssertNil(personEncouterResult)

		let locationVisitResult = fetchEntries(for: "LocationVisit", with: locationVisitId, from: databaseQueue)
		XCTAssertNil(locationVisitResult)
	}

	func test_OrderIsCorrect() {
		let databaseQueue = makeDatabaseQueue()
		let store = makeContactDiaryStore(with: databaseQueue)

		addContactPerson(name: "Adam Sandale", to: store)
		addContactPerson(name: "Adam Sandale", to: store)
		addContactPerson(name: "Emma Hicks", to: store)

		addLocation(name: "Amsterdam", to: store)
		addLocation(name: "Berlin", to: store)
		addLocation(name: "Berlin", to: store)

		store.diaryDaysPublisher.sink { diaryDays in
			let storedNames: [String] =
				diaryDays[0].entries.map { entry in
					switch entry {
					case .contactPerson(let person):
						return person.name
					case .location(let location):
						return location.name
					}
				}

			let expectedNames = [
				"Adam Sandale",
				"Adam Sandale",
				"Emma Hicks",
				"Amsterdam",
				"Berlin",
				"Berlin"
			]

			XCTAssertEqual(storedNames, expectedNames)

			let storedIds: [Int] =
				diaryDays[0].entries.map { entry in
					switch entry {
					case .contactPerson(let person):
						return person.id
					case .location(let location):
						return location.id
					}
				}

			let expectedIds = [
				Int(1),
				Int(2),
				Int(3),
				Int(1),
				Int(2),
				Int(3)
			]

			XCTAssertEqual(storedIds, expectedIds)
		}.store(in: &subscriptions)
	}

	func test_When_ContactPersonNameIsToLong_Then_ContactPersonNameIsTruncated() {
		let databaseQueue = makeDatabaseQueue()
		let store = makeContactDiaryStore(with: databaseQueue)

		let stringWith251Chars = String(repeating: "Y", count: 251) //(0...250).map { "Y" }

		let addPersonResult = store.addContactPerson(name: stringWith251Chars)
		guard case .success(let personId) = addPersonResult,
			  let contactPerson = fetchEntries(for: "ContactPerson", with: personId, from: databaseQueue),
			  let name = contactPerson.string(forColumn: "name")else {
			fatalError("An error is not expected.")
		}

		let expectedName = String(repeating: "Y", count: 250)

		XCTAssertEqual(name, expectedName)

		let updateResult = store.updateContactPerson(id: personId, name: stringWith251Chars)

		guard case .success = updateResult,
			  let contactPersonUpdated = fetchEntries(for: "ContactPerson", with: personId, from: databaseQueue),
			  let nameUpdated = contactPersonUpdated.string(forColumn: "name")  else {
			fatalError("An error is not expected.")
		}

		XCTAssertEqual(nameUpdated, expectedName)
	}

	func test_When_LocationNameIsToLong_Then_LocationNameIsTruncated() {
		let databaseQueue = makeDatabaseQueue()
		let store = makeContactDiaryStore(with: databaseQueue)

		let stringWith251Chars = String(repeating: "Y", count: 251)

		let addLocationResult = store.addLocation(name: stringWith251Chars)
		guard case .success(let locationId) = addLocationResult,
			  let location = fetchEntries(for: "Location", with: locationId, from: databaseQueue),
			  let name = location.string(forColumn: "name")else {
			fatalError("An error is not expected.")
		}

		let expectedName = String(repeating: "Y", count: 250)

		XCTAssertEqual(name, expectedName)

		let updateResult = store.updateLocation(id: locationId, name: stringWith251Chars)

		guard case .success = updateResult,
			  let locationUpdated = fetchEntries(for: "Location", with: locationId, from: databaseQueue),
			  let nameUpdated = locationUpdated.string(forColumn: "name")  else {
			fatalError("An error is not expected.")
		}

		XCTAssertEqual(nameUpdated, expectedName)
	}

	private func checkLocationEntry(entry: DiaryEntry, name: String, id: Int, isSelected: Bool) {
		guard case .location(let location) = entry else {
			fatalError("Not expected")
		}
		XCTAssertEqual(location.name, name)
		XCTAssertEqual(location.id, id)
		XCTAssertEqual(entry.isSelected, isSelected)
	}

	private func checkPersonEntry(entry: DiaryEntry, name: String, id: Int, isSelected: Bool) {
		guard case .contactPerson(let person) = entry else {
			fatalError("Not expected")
		}
		XCTAssertEqual(person.name, name)
		XCTAssertEqual(person.id, id)
		XCTAssertEqual(entry.isSelected, isSelected)
	}

	private func fetchEntries(for table: String, with id: Int, from databaseQueue: FMDatabaseQueue) -> FMResultSet? {
		var result: FMResultSet?

		databaseQueue.inDatabase { database in
			let sql =
			"""
				SELECT
					*
				FROM
					\(table)
				WHERE
					id = '\(id)'
			;
			"""

			guard let queryResult = database.executeQuery(sql, withParameterDictionary: nil) else {
				return
			}

			guard queryResult.next() else {
				return
			}

			result = queryResult
		}

		return result
	}

	@discardableResult
	private func addContactPerson(name: String, to store: ContactDiaryStoreV1) -> Int {
		let addContactPersonResult = store.addContactPerson(name: name)
		guard case let .success(contactPersonId) = addContactPersonResult else {
			fatalError("Failed to add ContactPerson")
		}
		return contactPersonId
	}

	@discardableResult
	private func addLocation(name: String, to store: ContactDiaryStoreV1) -> Int {
		let addLocationResult = store.addLocation(name: name)
		guard case let .success(locationId) = addLocationResult else {
			fatalError("Failed to add Location")
		}
		return locationId
	}

	@discardableResult
	private func addLocationVisit(locationId: Int, date: Date, store: ContactDiaryStoreV1) -> Int {
		let dateString = dateFormatter.string(from: date)
		let addLocationVisitResult = store.addLocationVisit(locationId: locationId, date: dateString)
		guard case let .success(locationVisitId) = addLocationVisitResult else {
			fatalError("Failed to add LocationVisit")
		}
		return locationVisitId
	}

	@discardableResult
	private func addPersonEncounter(personId: Int, date: Date, store: ContactDiaryStoreV1) -> Int {
		let dateString = dateFormatter.string(from: date)
		let addEncounterResult = store.addContactPersonEncounter(contactPersonId: personId, date: dateString)
		guard case let .success(encounterId) = addEncounterResult else {
			fatalError("Failed to add ContactPersonEncounter")
		}
		return encounterId
	}

	private func makeDatabaseQueue() -> FMDatabaseQueue {
		guard let databaseQueue = FMDatabaseQueue(path: "file::memory:") else {
			fatalError("Could not create FMDatabaseQueue.")
		}
		return databaseQueue
	}

	private func makeContactDiaryStore(with databaseQueue: FMDatabaseQueue) -> ContactDiaryStoreV1 {
		let schema = ContactDiaryStoreSchemaV1(databaseQueue: databaseQueue)

		return ContactDiaryStoreV1(
			databaseQueue: databaseQueue,
			schema: schema,
			key: "Dummy"
		)
	}

	private var dateFormatter: ISO8601DateFormatter = {
		let dateFormatter = ISO8601DateFormatter()
		dateFormatter.formatOptions = [.withFullDate]
		return dateFormatter
	}()

	// swiftlint:disable:next file_length
}
