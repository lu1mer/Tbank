// HomeViewController.swift
import UIKit
import DGCharts

class HomeViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let budgetLabel: UILabel = {
        let label = UILabel()
        label.text = "Бюджет"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private let spendingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Траты за май"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    private let spendingAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "checkmark.circle.fill")
        iv.tintColor = .systemGreen
        return iv
    }()
    
    private lazy var pieChartView: DGCharts.PieChartView = {
        let chart = PieChartView()
        chart.holeColor = .clear
        chart.holeRadiusPercent = 0.7
        chart.transparentCircleRadiusPercent = 0
        chart.legend.enabled = false
        chart.rotationEnabled = false
        chart.highlightPerTapEnabled = true
        chart.delegate = self
        return chart
    }()
    
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Все категории", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.identifier)
        tv.separatorStyle = .none
        tv.dataSource = self
        tv.delegate = self
        tv.rowHeight = 72
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    // MARK: - Properties
    private var selectedCategory: String?
    private var transactions: [Transaction] = []
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Главная"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [budgetLabel, amountLabel, spendingTitleLabel, spendingAmountLabel,
         checkmarkImageView, pieChartView, filterLabel, filterButton, tableView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            budgetLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            budgetLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            amountLabel.topAnchor.constraint(equalTo: budgetLabel.bottomAnchor, constant: 4),
            amountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            spendingTitleLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 24),
            spendingTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            spendingAmountLabel.topAnchor.constraint(equalTo: spendingTitleLabel.bottomAnchor, constant: 4),
            spendingAmountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            checkmarkImageView.centerYAnchor.constraint(equalTo: spendingAmountLabel.centerYAnchor),
            checkmarkImageView.leadingAnchor.constraint(equalTo: spendingAmountLabel.trailingAnchor, constant: 8),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 20),
            
            pieChartView.topAnchor.constraint(equalTo: spendingAmountLabel.bottomAnchor, constant: 24),
            pieChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pieChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            pieChartView.heightAnchor.constraint(equalToConstant: 200),
            
            filterLabel.topAnchor.constraint(equalTo: pieChartView.bottomAnchor, constant: 24),
            filterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            filterButton.centerYAnchor.constraint(equalTo: filterLabel.centerYAnchor),
            filterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        ])
    }
    
    // MARK: - Data
    private func loadData() {
        transactions = FinancialDataManager.shared.transactions
        updateFilteredTransactions()
    }
    
    private func refreshData() {
        FinancialDataManager.shared.recalculateMonthlySpending()
        loadData()
        updateUI()
    }
    
    private func updateFilteredTransactions() {
        transactions = FinancialDataManager.shared.getTransactions(for: selectedCategory)
        tableView.reloadData()
    }
    
    private func updateUI() {
        amountLabel.text = FinancialDataManager.shared.currentBalance.formattedCurrency
        spendingAmountLabel.text = FinancialDataManager.shared.monthlySpending.values.reduce(0, +).formattedCurrency
        filterLabel.text = dateFormatter.string(from: Date())
        filterButton.setTitle(selectedCategory ?? "Все категории", for: .normal)
        updateChart()
    }
    
    private func updateChart() {
        let spendingData = FinancialDataManager.shared.monthlySpending
        let entries = spendingData.map { PieChartDataEntry(value: $0.value, label: $0.key) }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.colors = ChartColorTemplates.pastel()
        set.drawValuesEnabled = true // Включаем отображение значений
        set.valueFormatter = CustomValueFormatter() // Наш кастомный форматтер
        set.selectionShift = 5
        
        let data = PieChartData(dataSet: set)
        pieChartView.data = data
        
        pieChartView.animate(yAxisDuration: 1.0, easingOption: .easeOutBack)
    }
    
    // MARK: - Actions
    @objc private func filterButtonTapped() {
        let alert = UIAlertController(title: "Выберите категорию", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Все категории", style: .default) { _ in
            self.selectedCategory = nil
            self.updateFilteredTransactions()
            self.updateUI()
        })
        
        FinancialDataManager.shared.selectedCategories.forEach { category in
            alert.addAction(UIAlertAction(title: category, style: .default) { _ in
                self.selectedCategory = category
                self.updateFilteredTransactions()
                self.updateUI()
            })
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.identifier, for: indexPath) as! TransactionCell
        cell.configure(with: transactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !transactions.isEmpty else { return nil }
        
        let header = UIView()
        let label = UILabel()
        label.text = dateFormatter.string(from: transactions[0].date)
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGray
        
        header.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

// MARK: - ChartViewDelegate
extension HomeViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let pieEntry = entry as? PieChartDataEntry else { return }
        selectedCategory = pieEntry.label
        updateFilteredTransactions()
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        selectedCategory = nil
        updateFilteredTransactions()
    }
}

// MARK: - Extensions
// Оставьте это расширение в вашем коде (оно не конфликтует с Charts)
extension Double {
    var formattedCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₽"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "\(self) ₽"
    }
}

// Добавьте в HomeViewController или в отдельный файл
class CustomValueFormatter: ValueFormatter {
    func stringForValue(_ value: Double,
                       entry: ChartDataEntry,
                       dataSetIndex: Int,
                       viewPortHandler: ViewPortHandler?) -> String {
        return value.formattedCurrency // Используем ваше расширение
    }
}
