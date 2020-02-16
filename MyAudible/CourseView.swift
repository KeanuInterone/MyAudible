//
//  CourseView.swift
//  MyAudible
//
//  Created by Keanu Interone on 2/16/20.
//  Copyright © 2020 Keanu Interone. All rights reserved.
//

import SwiftUI

struct CourseView: View {
    
    let course: Course
    
    init(course: Course) {
        self.course = course
    }
    
    var body: some View {
        Text(course.name)
    }
}

struct CourseView_Previews: PreviewProvider {
    
    static var previews: some View {
        CourseView(course: Course(name: "Name", imageUrl: "String"))
    }
}
