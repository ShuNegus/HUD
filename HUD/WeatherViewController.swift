import UIKit

class WeatherViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var temperatureOutput: UILabel!

    // MARK: - Internal properties

    // Константа
    let  weatherManager = WeatherManager()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
    }
}

// MARK: - WeatherDelegate

extension WeatherViewController: WeatherDelegate {

    func weatherManager(_ weatherManager: WeatherManager, didUpdate temperature: String) {
        temperatureOutput?.text = temperature
        print(temperature)
    }

    func weatherManager(_ weatherManager: WeatherManager, didRecive error: String) {
        temperatureOutput?.text = error
        print(error)
    }
}
