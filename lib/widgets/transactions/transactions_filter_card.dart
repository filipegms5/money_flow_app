import 'package:flutter/material.dart';
import 'package:money_flow_app/models/categoria_model.dart';
import 'package:money_flow_app/widgets/transactions/filter_header.dart';
import 'package:money_flow_app/widgets/transactions/date_filter_fields.dart';
import 'package:money_flow_app/widgets/transactions/description_filter_field.dart';
import 'package:money_flow_app/widgets/transactions/category_filter_field.dart';
import 'package:money_flow_app/widgets/transactions/filter_action_buttons.dart';

class TransactionsFilterCard extends StatefulWidget {
  final List<Categoria> categorias;
  final Function(DateTime?, DateTime?, String, Categoria?) onFilterApply;
  final VoidCallback onFilterClear;

  const TransactionsFilterCard({
    super.key,
    required this.categorias,
    required this.onFilterApply,
    required this.onFilterClear,
  });

  @override
  State<TransactionsFilterCard> createState() => _TransactionsFilterCardState();
}

class _TransactionsFilterCardState extends State<TransactionsFilterCard> {
  bool _filtersExpanded = false;
  final TextEditingController _descriptionFilterController = TextEditingController();
  Categoria? _selectedCategoria;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _descriptionFilterController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
      _applyFilter();
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
      _applyFilter();
    }
  }

  void _applyFilter() {
    widget.onFilterApply(
      _startDate,
      _endDate,
      _descriptionFilterController.text.trim(),
      _selectedCategoria,
    );
  }

  void _clearFilter() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _descriptionFilterController.clear();
      _selectedCategoria = null;
    });
    widget.onFilterClear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilterHeader(
            isExpanded: _filtersExpanded,
            onTap: () {
              setState(() {
                _filtersExpanded = !_filtersExpanded;
              });
            },
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _filtersExpanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DateFilterFields(
                          startDate: _startDate,
                          endDate: _endDate,
                          onStartDateSelected: _selectStartDate,
                          onEndDateSelected: _selectEndDate,
                        ),
                        const SizedBox(height: 12),
                        DescriptionFilterField(
                          controller: _descriptionFilterController,
                          onChanged: _applyFilter,
                        ),
                        const SizedBox(height: 12),
                        CategoryFilterField(
                          selectedCategoria: _selectedCategoria,
                          categorias: widget.categorias,
                          onChanged: (Categoria? value) {
                            setState(() {
                              _selectedCategoria = value;
                            });
                            _applyFilter();
                          },
                        ),
                        const SizedBox(height: 12),
                        FilterActionButtons(
                          onClear: _clearFilter,
                          onFilter: _applyFilter,
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

