import SwiftUI
import UIKit
import Firebase


struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct values{
    
    var heart: String
    var sleep: String
    var calories: String
    var steps: String
    var running: String
    var cycling: String
    
}

struct Datas: Identifiable{
    var id : Int
    var title : String
    var image : String

}

//Home View
struct Home : View {
    
    @State var index = 0
    @State var show = false
    @State var k=0
    
    @ObservedObject var value = getData()
    
    var body: some View{
        if self.value.value != nil{
            ZStack{
                Color("Back")
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack{
                    
                    HStack{
                        Text("MyFitnessPal")
                            .font(.custom("Chalkboard", size: 35))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        
                        Button(action:{
                            self.value.value = nil
                            self.value.updateData()
                        }){
                            
                            Image("health-app")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(.bottom,7)
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.top,30)
                    .padding(.bottom,-27)
                    
                    
                    // Tab View...
                    HStack(spacing: 0){
                        
                        Text("Dashboard")
                            .foregroundColor(self.index == 0 ? .white : Color("Color").opacity(0.7))
                            .fontWeight(.bold)
                            .padding(.vertical,10)
                            .padding(.horizontal,20)
                            .background(Color("Color").opacity(self.index == 0 ? 1 : 0))
                            .clipShape(Capsule())
                            .onTapGesture {
                                withAnimation(.default){
                                    self.index = 0
                                    self.k=self.index
                                }
                            }
                        
                        Spacer()
                        
                        Button(action:{
                            
                            self.show.toggle()
                            self.index=self.k
                            
                        }){
                            Text("Add Data")
                                .foregroundColor(self.index == 1 ? .white : Color("Color").opacity(0.7))
                                .fontWeight(.bold)
                                .padding(.vertical,10)
                                .padding(.horizontal,20)
                                //.background(Color("Color").opacity(self.index == 1 ? 1 : 0))
                                .clipShape(Capsule())
                        }
                        .sheet(isPresented: $show){
                            Form(isPresented: $show)
                        }
                        
                        Spacer()
                        
                        Text("Stats")
                            .foregroundColor(self.index == 2 ? .white : Color("Color").opacity(0.7))
                            .fontWeight(.bold)
                            .padding(.vertical,10)
                            .padding(.horizontal,30)
                            .background(Color("Color").opacity(self.index == 2 ? 1 : 0))
                            .clipShape(Capsule())
                            .onTapGesture {
                                withAnimation(.default){
                                    self.index = 2
                                    self.k=self.index
                                }
                            }
                        
                    }
                    .background(Color.white.opacity(0.02))
                    .clipShape(Capsule())
                    .padding(.horizontal)
                    .padding(.top,45)
                    
                    //Form Button
                    
                    
                    
                    
                    // DashBoard Grid....
                    HStack{
                        TabView(selection: self.$index){
                            
                            GridView(fitness_Data: fit_Data, value: self.value.value)
                                .tag(0)
                                                        
                            //GRAPH
                            VStack{
                                ZStack{
                                    ProgressBar(height:300, to: CGFloat(CGFloat(truncating: NSNumber(value:Int(self.value.value.steps) ?? 0))/10000), color: .red)
                                    ProgressBar(height:230, to:CGFloat(CGFloat(truncating: NSNumber(value:Int(self.value.value.calories) ?? 0))/900), color: .yellow)
                                    ProgressBar(height:160, to:CGFloat(CGFloat(truncating: NSNumber(value:Int(self.value.value.running) ?? 0))/10), color: Color("Color1"))
                                }
                                HStack(spacing: 20){
                                    HStack{
                                        Image("footprint")
                                            .resizable()
                                            .frame(width: 55, height: 55)
                                        
                                        VStack(alignment: .leading, spacing:12 ){
                                            Text("Steps")
                                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                .foregroundColor(.red)
                                            Text("\(self.value.value.steps)/10000 steps")
                                                .foregroundColor(.white)
                                        }
                                    }
                                    
                                    HStack{
                                        Image("calories")
                                            .resizable()
                                            .frame(width: 55, height: 55)
                                        
                                        VStack(alignment: .leading, spacing:12 ){
                                            Text("Calories")
                                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                .foregroundColor(.yellow)
                                            Text("\(self.value.value.calories)/900 kcal")
                                                .foregroundColor(.white)
                                        }
                                    }
                                }.padding(.top,70)
                                
                                HStack(spacing: 20){
                                    HStack{
                                        Image("bicycle")
                                            .resizable()
                                            .frame(width: 55, height: 55)
                                        
                                        VStack(alignment: .leading, spacing:12 ){
                                            Text("Cycling")
                                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                .foregroundColor(Color("Color1"))
                                            Text("\(self.value.value.cycling)/20 km")
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .padding(.top,20)
                            }
                            .tag(2)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                }
            }
            
        }
        
        
        else{
            ActivityIndicator()
        }
    }
}

// Grid View
struct GridView : View {
    
    var fitness_Data : [Datas]
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    var value: values
    //let val_run = CGFloat(CGFloat(truncating: NSNumber(value:Int(self.value.value.running) ?? 0))
    
    var body: some View{
        
        LazyVGrid(columns: columns,spacing: 30){
            
            ForEach(fitness_Data){datas in
                
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text(datas.title)
                            .foregroundColor(.white)
                        
                        
                        //Heart
                        if(datas.id==0)
                        {
                            Text("\(self.value.heart) bpm")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top,10)
                            
                            HStack{

                                Spacer(minLength: 0)
                                Text("Healthy\n80-120")
                                    .foregroundColor(.white)

                            }
                        }
                        
                        
                        //Sleep
                        else if(datas.id==1)
                        {
                            Text("\(self.value.sleep)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top,10)

                            HStack{

                                Spacer(minLength: 0)
                                Text("Deep Sleep\n7h 30m")
                                    .foregroundColor(.white)

                            }
                        }
                        
                        
                        //Calories
                        else if(datas.id==2)
                        {
                            Text("\(self.value.calories) Kcal")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top,10)
                            
                            if(CGFloat(CGFloat(truncating: NSNumber(value:Int(self.value.calories) ?? 0)))>=900)
                            {
                                HStack{

                                    Spacer(minLength: 0)
                                    Text("Goal Complete\n900 Kcal")
                                        .foregroundColor(.white)

                                }

                            }
                            else{
                                HStack{

                                    Spacer(minLength: 0)
                                    Text("Daily Goal\n900 kcal")
                                        .foregroundColor(.white)

                                }
                            }
                        }

                        
                        
                        //Steps
                        else if(datas.id==3)
                        {
                            Text("\(self.value.steps)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top,10)
                            
                            if(CGFloat(CGFloat(truncating: NSNumber(value:Int(self.value.steps) ?? 0)))>=10000)
                            {
                                HStack{

                                    Spacer(minLength: 0)
                                    Text("Goal Complete\n10,000 steps")
                                        .foregroundColor(.white)

                                }

                            }
                            else{
                                HStack{

                                    Spacer(minLength: 0)
                                    Text("Daily Goal\n10,000 Steps")
                                        .foregroundColor(.white)

                                }
                            }
                        }


                        //Running
                        else if(datas.id==4)
                        {
                            Text("\(self.value.running) km")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top,10)
                            
                            if(CGFloat(CGFloat(truncating: NSNumber(value:Int(self.value.running) ?? 0)))>=10)
                            {
                                HStack{

                                    Spacer(minLength: 0)
                                    Text("Goal Complete\n10 km")
                                        .foregroundColor(.white)

                                }

                            }
                            else{
                                HStack{

                                    Spacer(minLength: 0)
                                    Text("Daily Goal\n10 km")
                                        .foregroundColor(.white)

                                }
                            }
                            
                            
                        }
                        
                        
                        //Cycling
                        else
                        {
                            Text("\(self.value.cycling) km")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top,10)
                            
                            if(CGFloat(CGFloat(truncating: NSNumber(value:Int(self.value.cycling) ?? 0)))>=20)
                            {
                                HStack{
                                    
                                    Spacer(minLength: 0)
                                    Text("Goal Complete\n20 km")
                                        .foregroundColor(.white)
                                    
                                }
                                
                            }
                            else{
                                HStack{
                                    
                                    Spacer(minLength: 0)
                                    Text("Daily Goal\n20 km")
                                        .foregroundColor(.white)
                                    
                                }
                            }
                            
                        }

                            
                    }
                    .padding()
                    // image name same as color name....
                    .background(Color(datas.image))
                    .cornerRadius(20)
                    // shadow....
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    
                    // top Image....
                    
                    Image(datas.image)
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.white.opacity(0.12))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal)
        .padding(.top,25)
    }
}

//Form View
struct Form : View {
    
    @State var heart=""
    @State var sleep=""
    @State var calories=""
    @State var steps=""
    @State var running=""
    @State var cycling=""
    
    @State var dismissView = false
    @Binding var isPresented: Bool
    
    @ObservedObject var data = getData()
    @ObservedObject var newVal = newData()
    
    
    
    
    var body: some View {
        
        NavigationView {
            List {
                
                VStack(alignment: .leading) {
                    
                    
                    // Heart rate
                    VStack(alignment: .leading) {
                        Text("Enter heart rate")
                            .font(.headline)
                        TextField("Heart Rate", text: $heart)
                            .padding(.all)
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                    }
                    .padding(.horizontal, 15)
                    
                    
                    // Sleep goal
                    VStack(alignment: .leading) {
                        Text("Enter sleep time")
                            .font(.headline)
                        TextField("Sleep Time", text: $sleep)
                            .padding(.all)
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                    }
                    .padding(.horizontal, 15)
                    
                    
                    //Calories
                    VStack(alignment: .leading) {
                        Text("Enter calories burned")
                            .font(.headline)
                        TextField("Calories Burned", text: $calories)
                            .padding(.all)
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                    }
                    .padding(.horizontal, 15)
                    
                    
                    //Steps
                    
                    VStack(alignment: .leading) {
                        Text("Enter number of steps")
                            .font(.headline)
                        TextField("Steps", text: $steps)
                            .padding(.all)
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                    }
                    .padding(.horizontal, 15)
                    
                    //Running
                    VStack(alignment: .leading) {
                        Text("Enter running distance")
                            .font(.headline)
                        TextField("Running Distance", text: $running)
                            .padding(.all)
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                    }
                    .padding(.horizontal, 15)
                    
                    //Cycling
                    VStack(alignment: .leading) {
                        Text("Enter cycling distance")
                            .font(.headline)
                        TextField("Cycling Distance", text: $cycling)
                            .padding(.all)
                            .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                    }
                    .padding(.horizontal, 15)
                }
                .padding(.top, 20)
                .listRowInsets(EdgeInsets())
                
                //Save button
                Button(action: {
                    newVal.newData(heart: heart, sleep: sleep, calories: calories, steps: steps, running: running, cycling: cycling)
                    self.isPresented = false
                }) {
                    HStack {
                        Spacer()
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                }
                .padding(.vertical, 10.0)
                .background(Color("Color"))
                .padding(.horizontal, 50)
                .padding(.bottom, 10.0)
            }
            .navigationBarTitle(Text("Health Data"))
            .navigationBarItems(trailing:
                                    Button(action: {
                                        
                                        self.isPresented = false
                                        
                                    }, label: {
                                        Text("Cancel")
                                            .foregroundColor(Color("Color"))
                                    })
                                
            )
        }
        .sheet(isPresented: $dismissView) {
            Form(isPresented: self.$dismissView)
        }
        
    }
    
}

//Update data in database
class newData: ObservableObject{
    
    init(){
    }
    
    func newData(heart: String, sleep: String, calories: String, steps: String, running: String, cycling: String){
        let db = Firestore.firestore()
        
        db.collection("Data").document("Home").getDocument{ (snap,err) in
            
            if err != nil{
                
                print((err?.localizedDescription) ?? "")
                return
            }
            
            snap?.reference.updateData([
                
                "heart": heart,
                "sleep": sleep,
                "calories": calories,
                "steps": steps,
                "running": running,
                "cycling": cycling
                
            ])
        }
    }
}

//Retrieve data from database
var count = 0
class getData: ObservableObject{
    
    @Published var value: values!
    
    init(){
        if(count==0)
        {
            FirebaseApp.configure()
        }
        count=1
        updateData()
        
    }
    func updateData(){
        
        
        let db = Firestore.firestore()
        
        db.collection("Data").document("Home").getDocument{ (snap,err) in
            
            if err != nil{
                
                print((err?.localizedDescription) ?? "")
                return
            }
            
            let steps=snap?.get("steps") as! NSString
            let calories=snap?.get("calories") as! NSString
            let cycling=snap?.get("cycling") as! NSString
            let heart=snap?.get("heart") as! NSString
            let running=snap?.get("running") as! NSString
            let sleep=snap?.get("sleep") as! NSString
            
            DispatchQueue.main.async{
                
                self.value=values(heart:heart as String, sleep:sleep as String, calories: calories as String, steps: steps as String, running: running as String, cycling:cycling as String)
            }
        }
    }
}

//Graph
struct ProgressBar: View {
    var height: CGFloat
    var to: CGFloat
    var color: Color
    
    var body : some View{
        ZStack{
            
            Circle()
                .trim(from: 0, to: 1)
                .stroke(Color.black.opacity(0.25), style:StrokeStyle(lineWidth: 30, lineCap: .round))
                .frame(height: height)
            
            Circle()
                .trim(from: 0, to: to)
                .stroke(color, style:StrokeStyle(lineWidth: 30, lineCap: .round))
                .frame(height: height)
        }
        .rotationEffect(.init(degrees: 270))
    }
}

// Loading Indicator
struct ActivityIndicator: UIViewRepresentable {
    
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
    }
}


// Daily Data...
var fit_Data = [
    
    Datas(id: 0, title: "Heart Rate", image: "heart"),
    
    Datas(id: 1, title: "Sleep", image: "sleep"),
    
    Datas(id: 2, title: "Calories", image: "energy"),
    
    Datas(id: 3, title: "Steps", image: "steps"),
    
    Datas(id: 4, title: "Running", image: "running"),
    
    Datas(id: 5, title: "Cycling", image: "cycle"),
]
