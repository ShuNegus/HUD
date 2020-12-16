import UIKit

class WeatherViewController: UIViewController {
    
    
    @IBOutlet weak var temperatureOutput: UILabel!
    
    var weatherManager: WeatherManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager = WeatherManager()
        weatherManager.delegate = self
        
    }


}
extension WeatherViewController: WeatherDelegate {
    func weatherDidUpdate(temperature: String){
        temperatureOutput?.text = temperature
        print(temperature)
    }
}
