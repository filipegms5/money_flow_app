import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_flow_app/controllers/meta_financeira_controller.dart';

class CriarMetaForm extends StatefulWidget {
  const CriarMetaForm({super.key});

  @override
  State<CriarMetaForm> createState() => _CriarMetaFormState();
}

class _CriarMetaFormState extends State<CriarMetaForm> {
  final _formKey = GlobalKey<FormState>();
  final MetaFinanceiraController _controller = MetaFinanceiraController();
  
  // Controllers for text fields
  final _valorController = TextEditingController();
  final _descricaoController = TextEditingController();
  
  // Form state
  DateTime _dataInicio = DateTime.now();
  DateTime _dataFim = DateTime.now().add(const Duration(days: 30));
  bool _isSubmitting = false;
  
  @override
  void dispose() {
    _valorController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }
  
  Future<void> _selectDataInicio(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataInicio,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _dataInicio) {
      setState(() {
        _dataInicio = picked;
        if (_dataFim.isBefore(_dataInicio)) {
          _dataFim = _dataInicio.add(const Duration(days: 1));
        }
      });
    }
  }
  
  Future<void> _selectDataFim(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataFim,
      firstDate: _dataInicio.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _dataFim) {
      setState(() {
        _dataFim = picked;
      });
    }
  }
  
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isSubmitting = true;
    });
    
    try {
      final metaData = {
        'valor': double.parse(_valorController.text),
        'data_inicio': _dataInicio.toIso8601String().substring(0, 10),
        'data_fim': _dataFim.toIso8601String().substring(0, 10),
        if (_descricaoController.text.isNotEmpty) 'descricao': _descricaoController.text,
      };
      
      await _controller.createMeta(metaData);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meta criada com sucesso!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar meta: $e')),
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Valor field
          TextFormField(
            controller: _valorController,
            decoration: const InputDecoration(
              labelText: 'Valor da Meta *',
              border: OutlineInputBorder(),
              prefixText: 'R\$ ',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o valor da meta';
              }
              if (double.tryParse(value) == null) {
                return 'Valor inválido';
              }
              if (double.parse(value) <= 0) {
                return 'Valor deve ser maior que zero';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          
          // Data Início field
          InkWell(
            onTap: () => _selectDataInicio(context),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Data de Início *',
                border: OutlineInputBorder(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('dd/MM/yyyy').format(_dataInicio)),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          
          // Data Fim field
          InkWell(
            onTap: () => _selectDataFim(context),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Data de Fim *',
                border: OutlineInputBorder(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('dd/MM/yyyy').format(_dataFim)),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          
          // Descrição field
          TextFormField(
            controller: _descricaoController,
            decoration: const InputDecoration(
              labelText: 'Descrição',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24.0),
          
          // Submit button
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: _isSubmitting
                ? const CircularProgressIndicator()
                : const Text('Criar Meta'),
          ),
        ],
      ),
    );
  }
}

