//
//  SymptomRepository.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/26.
//

import Foundation
import SQLite3

protocol SymptomRepository {
    static var shared: SymptomRepository { get }
    
    func create(content: String)
    func findAll() -> [Symptom]
    func update(id: Int, content: String)
    func delete(id: Int)
}

class SQLite3SymptomRepository: SymptomRepository {
    static let shared: SymptomRepository = SQLite3SymptomRepository()
    var db: OpaquePointer?
    
    private init() {
        self.db = createDb()
        createTable()
        print("successfully create SQLiteSymptomRepository")
    }
    
    private func createDb() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        
        let fileManager = FileManager.default
        let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let directoryPath = documentPath.appendingPathComponent("symptom")
        let filePath = directoryPath.appendingPathComponent("symptom.db")
        
        do {
            try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: false)
        } catch {
            print("Directory Already Exist")
        }
        
        guard sqlite3_open(filePath.path, &db) == SQLITE_OK else {
            let msg = String(cString: sqlite3_errmsg(db))
            print("error on SQLiteSymptomRepository.createDb(): \(msg)")
            return nil
        }
        
        return db
    }
    
    private func createTable() {
        let query = "create table if not exists symptom(id integer primary key autoincrement, content text, date timestamp default current_timestamp);"
        var stmt: OpaquePointer?
        
        defer { sqlite3_finalize(stmt) }
        
        guard sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK else {
            let msg = String(cString: sqlite3_errmsg(db))
            print("error on SQLiteSymptomRepository.createDb(): \(msg)")
            return
        }
        
        guard sqlite3_step(stmt) == SQLITE_DONE else {
            print("table symptom not created")
            return
        }
    }
    
    func create(content: String) {
        // TODO: Parameter Binding 적용
        let query = "insert into symptom(content) values('\(content)');"
        var stmt: OpaquePointer?
        
        defer { sqlite3_finalize(stmt) }
        
        guard sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK else {
            let msg = String(cString: sqlite3_errmsg(db))
            print("error on SQLiteSymptomRepository.findByName: \(msg)")
            return
        }
        
        guard sqlite3_step(stmt) == SQLITE_DONE else {
            print("symptom created")
            return
        }
    }
    
    func findAll() -> [Symptom] {
        let query = "select * from symptom order by date desc"
        var stmt: OpaquePointer?
        
        defer { sqlite3_finalize(stmt) }
        
        guard sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK else {
            let msg = String(cString: sqlite3_errmsg(db))
            print("error on SQLiteSymptomRepository.findAll: \(msg)")
            return []
        }
        
        var result = [Symptom]()
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(stmt, 0))
            let content = String(cString: sqlite3_column_text(stmt, 1))
            let dateString = String(cString: sqlite3_column_text(stmt, 2))
            result.append(Symptom(id: id, content: content, date: dateString.toDate()))
        }
        
        return result
    }
    
    func update(id: Int, content: String) {
        let query = "update symptom set content = '\(content)' where id = \(id);"
        var stmt: OpaquePointer?
        
        defer { sqlite3_finalize(stmt) }
        
        guard sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK else {
            let msg = String(cString: sqlite3_errmsg(db))
            print("error on SQLiteSymptomRepository.update: \(msg)")
            return
        }
        
        guard sqlite3_step(stmt) == SQLITE_DONE else {
            print("symptom \(id) not updated")
            return
        }
    }
    
    func delete(id: Int) {
        let query = "delete from symptom where id = \(id);"
        var stmt: OpaquePointer?
        
        defer { sqlite3_finalize(stmt) }
        
        guard sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK else {
            let msg = String(cString: sqlite3_errmsg(db))
            print("error on SQLiteSymptomRepository.delete: \(msg)")
            return
        }
        
        guard sqlite3_step(stmt) == SQLITE_DONE else {
            print("symptom \(id) not deleted")
            return
        }
    }
}
