// Credit: https://hixfield.medium.com/ios-wiget-with-firebase-auth-and-realtime-database-471a42377838

import FirebaseAuth
import Foundation
import OSLog

public extension FirebaseAuth.Auth {
    static func switchToUsingAppGroup(_ accessGroup: String) {
        do {
            try Auth.auth().useUserAccessGroup(accessGroup)
        } catch let error as NSError {
            print("Error changing user access group: %@", error)
        }
    }

    // it basically checks if Auth is already using the correct userAccessGroup and
    // if so, nothing needs to be done.
    // If not, the existing user is temporary saved,
    // then Firebase Auth is configured to use the Access Group and then the user is moved to it.
    static func migrateFirebaseAuthToAccessGroupIfNeeded(_ accessGroup: String) {
        let log = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: "FirebaseAuth.Auth"
        )
        let auth = Auth.auth()

        // get current user (so we can migrate later)
        guard let user = auth.currentUser else {
            log.debug("currentUser is nil")
            return
        }

        if auth.userAccessGroup == accessGroup {
            log.debug("Firebase Auth is already using the correct acces group \(accessGroup)")
            return
        }

        log.debug("Firebase Auth is not yet using correct access group \(accessGroup). 🔄 Migrating...")

        // for extension (widget) we want to share our auth status
        do {
            // switch to using app group
            try auth.useUserAccessGroup(accessGroup)

            // migrate current user
            auth.updateCurrentUser(user) { error in
                if let error {
                    log.error("Auth.auth().updateCurrentUser \(error.localizedDescription)")
                } else {
                    log.debug("Firebase Auth user migrated")
                }
            }

        } catch let error as NSError {
            log.error("❌ Error changing user access group \(accessGroup): \(error.localizedDescription)")
        }
    }
}
