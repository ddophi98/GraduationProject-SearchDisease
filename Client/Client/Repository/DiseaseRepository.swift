//
//  DiseaseRepository.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/26.
//

import Foundation
import SQLite3

protocol DiseaseRepository {
    static var shared: DiseaseRepository { get }
    
    func findByName(name: String) -> [Disease]
    func getSuspectedDisease(from: Date, to: Date) -> [Disease]
}

class SQLite3DiseaseRepository: DiseaseRepository {
    static let shared: DiseaseRepository = SQLite3DiseaseRepository()
    var db: OpaquePointer?
    
    private init() {
        self.db = createDb()
        print("successfully create SQLite3DiseaseRepository")
    }
    
    private func createDb() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        
        let filePath = Bundle.main.url(forResource: "disease", withExtension: "db")
        guard sqlite3_open(filePath?.path, &db) == SQLITE_OK else {
            let msg = String(cString: sqlite3_errmsg(db))
            print("error on SQLite3DiseaseRepository.createDb(): \(msg)")
            return nil
        }
        
        return db
    }
    
    func findByName(name: String) -> [Disease] {
        let query = "select * from disease where name like '%\(name)%'"
        var stmt: OpaquePointer?
        
        defer { sqlite3_finalize(stmt) }
        
        guard sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK else {
            let msg = String(cString: sqlite3_errmsg(db))
            print("error on SQLite3DiseaseRepository.findByName: \(msg)")
            return []
        }
        
        var result = [Disease]()
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(stmt, 0))
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let definition = String(cString: sqlite3_column_text(stmt, 2))
            let cause = String(cString: sqlite3_column_text(stmt, 3))
            let symptom = String(cString: sqlite3_column_text(stmt, 4))
            let dianosis = String(cString: sqlite3_column_text(stmt, 5))
            let cure = String(cString: sqlite3_column_text(stmt, 6))
            result.append(Disease(id: id, name: name, definition: definition, cause: cause, symptom: symptom, diagnosis: dianosis, cure: cure))
        }
        
        return result
    }
    
    // TODO: 구현
    func getSuspectedDisease(from: Date, to: Date) -> [Disease] {
        return [
            Disease(id: 1, name: "감기", definition: "감기정의", cause: "감기원인", symptom: "감기증상", diagnosis: "감기진단", cure: "감기치료"),
            Disease(id: 2, name: "코로나", definition: "코로나정의", cause: "코로나원인", symptom: "코로나증상", diagnosis: "코로나진단", cure: "코로나치료"),
            Disease(id: 3, name: "결핵", definition: "결핵정의", cause: "결핵원인", symptom: "결핵증상", diagnosis: "결핵진단", cure: "결핵치료"),
        ]
    }
}
