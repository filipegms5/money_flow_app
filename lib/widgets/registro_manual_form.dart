import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_flow_app/controllers/transacao_controller.dart';
import 'package:money_flow_app/models/forma_pagamento_model.dart';
import 'package:money_flow_app/controllers/categoria_controller.dart';
import 'package:money_flow_app/models/categoria_model.dart';

class RegistroManualForm extends StatefulWidget {
  const RegistroManualForm({super.key});

  @override
  State<RegistroManualForm> createState() => _RegistroManualFormState();
}

class _RegistroManualFormState extends State<RegistroManualForm> {
  final _formKey = GlobalKey<FormState>();
  final TransacoesController _controller = TransacoesController();
  final CategoriaController _categoriaController = CategoriaController();
  
  // Controllers for text fields
  final _valorController = TextEditingController();
  final _descricaoController = TextEditingController();
  
  // Form state
  DateTime _selectedDate = DateTime.now();
  String _selectedTipo = 'despesa';
  bool _recorrente = false;
  FormaPagamento? _selectedFormaPagamento;
  Categoria? _selectedCategoria;
  
  // Dropdown data
  List<FormaPagamento> _formasPagamento = [];
  List<Categoria> _categorias = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  
  @override
  void initState() {
    super.initState();
    _loadDropdownData();
  }
  
  @override
  void dispose() {
    _valorController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }
  
  Future<void> _loadDropdownData() async {
    try {
      final formasPagamento = await _controller.fetchFormasPagamento();
      final categorias = await _categoriaController.fetchCategorias();
      
      setState(() {
        _formasPagamento = formasPagamento;
        _categorias = categorias;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: $e')),
        );
      }
    }
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_selectedFormaPagamento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma forma de pagamento')),
      );
      return;
    }
    
    setState(() {
      _isSubmitting = true;
    });
    
    try {
      final transacaoData = {
        'valor': double.parse(_valorController.text),
        'data': _selectedDate.toIso8601String().substring(0, 10),
        'tipo': _selectedTipo,
        if (_descricaoController.text.isNotEmpty) 'descricao': _descricaoController.text,
        'recorrente': _recorrente,
        'forma_pagamento_id': _selectedFormaPagamento!.id,
        if (_selectedCategoria != null) 'categoria_id': _selectedCategoria!.id,
      };
      
      await _controller.createTransacao(transacaoData);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transação criada com sucesso!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar transação: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ValorField(controller: _valorController),
              const SizedBox(height: 16.0),
              
              DatePickerField(
                selectedDate: _selectedDate,
                onDateSelected: (date) => setState(() => _selectedDate = date),
                selectDate: _selectDate,
              ),
              const SizedBox(height: 16.0),
              
              TipoDropdown(
                selectedTipo: _selectedTipo,
                onChanged: (value) => setState(() => _selectedTipo = value),
              ),
              const SizedBox(height: 16.0),
              
              DescricaoField(controller: _descricaoController),
              const SizedBox(height: 16.0),
              
              RecorrenteTile(
                value: _recorrente,
                onChanged: (value) => setState(() => _recorrente = value),
              ),
              const SizedBox(height: 16.0),
              
              FormaPagamentoDropdown(
                formasPagamento: _formasPagamento,
                selectedFormaPagamento: _selectedFormaPagamento,
                onChanged: (value) => setState(() => _selectedFormaPagamento = value),
              ),
              const SizedBox(height: 16.0),

              // Categoria (opcional)
              DropdownButtonFormField<Categoria>(
                value: _selectedCategoria,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                items: _categorias.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat.nome),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategoria = value),
              ),
              const SizedBox(height: 24.0),
              
              SubmitButton(
                isSubmitting: _isSubmitting,
                onSubmit: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para campo de valor
class ValorField extends StatelessWidget {
  final TextEditingController controller;
  
  const ValorField({super.key, required this.controller});
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Valor *',
        border: OutlineInputBorder(),
        prefixText: 'R\$ ',
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe o valor';
        }
        if (double.tryParse(value) == null) {
          return 'Valor inválido';
        }
        return null;
      },
    );
  }
}

// Widget para seletor de data
class DatePickerField extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Function(BuildContext) selectDate;
  
  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.selectDate,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Data *',
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}

// Widget para dropdown de tipo
class TipoDropdown extends StatelessWidget {
  final String selectedTipo;
  final Function(String) onChanged;
  
  const TipoDropdown({
    super.key,
    required this.selectedTipo,
    required this.onChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedTipo,
      decoration: const InputDecoration(
        labelText: 'Tipo *',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'despesa', child: Text('Despesa')),
        DropdownMenuItem(value: 'receita', child: Text('Receita')),
      ],
      onChanged: (value) => onChanged(value!),
    );
  }
}

// Widget para campo de descrição
class DescricaoField extends StatelessWidget {
  final TextEditingController controller;
  
  const DescricaoField({super.key, required this.controller});
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Descrição',
        border: OutlineInputBorder(),
      ),
      maxLines: 2,
    );
  }
}

// Widget para checkbox de transação recorrente
class RecorrenteTile extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  
  const RecorrenteTile({
    super.key,
    required this.value,
    required this.onChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text('Transação Recorrente'),
      value: value,
      onChanged: (newValue) => onChanged(newValue ?? false),
    );
  }
}

// Widget para dropdown de forma de pagamento
class FormaPagamentoDropdown extends StatelessWidget {
  final List<FormaPagamento> formasPagamento;
  final FormaPagamento? selectedFormaPagamento;
  final Function(FormaPagamento?) onChanged;
  
  const FormaPagamentoDropdown({
    super.key,
    required this.formasPagamento,
    required this.selectedFormaPagamento,
    required this.onChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<FormaPagamento>(
      value: selectedFormaPagamento,
      decoration: const InputDecoration(
        labelText: 'Forma de Pagamento *',
        border: OutlineInputBorder(),
      ),
      items: formasPagamento.map((forma) {
        return DropdownMenuItem(
          value: forma,
          child: Text(forma.nome ?? 'ID: ${forma.id}'),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Selecione uma forma de pagamento';
        }
        return null;
      },
    );
  }
}

// Widget para botão de submit
class SubmitButton extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onSubmit;
  
  const SubmitButton({
    super.key,
    required this.isSubmitting,
    required this.onSubmit,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isSubmitting ? null : onSubmit,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      child: isSubmitting
          ? const CircularProgressIndicator()
          : const Text('Criar Transação'),
    );
  }
}

