import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:icontrol/model/employee.dart';
import 'package:icontrol/model/equipment.dart';
import 'package:icontrol/model/task/task.dart';

import '../../config/application_messages.dart';
import '../../config/preferences.dart';
import '../../global/application_constant.dart';
import '../../model/brand.dart';
import '../../model/fleet.dart';
import '../../model/model.dart';
import '../../model/payment.dart';
import '../../model/user.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';
import '../components/custom_app_bar.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _Search();
}

class _Search extends State<Search> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  final postRequest = PostRequest();


  Future<List<Map<String, dynamic>>> listPayments() async {
    try {
      final body = {
        "id_usuario": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LIST_PAYMENTS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> createTokenCreditCard(String cardNumber,
      String expirationMonth,
      String expirationYear,
      String securityCode,
      String name,
      String document) async {
    try {
      final body = {
        "card_number": cardNumber,
        "expiration_month": expirationMonth,
        "expiration_year": expirationYear,
        "security_code": securityCode,
        "nome": name,
        "cpf": document,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.CREATE_TOKEN_CARD, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Payment.fromJson(parsedResponse);

      if (response.status == 400) {

        ApplicationMessages(context: context).showMessage("Não foi possível autenticar este cartão!");

      } else {

        // payWithCreditCard(_idOrder.toString(), _totalValue, response.id);
      }


      // setState(() {});

    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }


  Future<void> payWithCreditCard(String idOrder, String totalValue,
      String idCreditCard) async {
    try {
      final body = {
        "id_usuario": await Preferences.getUserData()!.id,
        "id_pedido": idOrder,
        "tipo_pagamento": ApplicationConstant.CREDIT_CARD,
        "payment_id": "",
        "valor": totalValue,
        "card": idCreditCard,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.ADD_PAYMENT, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Payment.fromJson(_map[0]);

      if (response.status == "01") {
        // setState(() {
        //   Navigator.pushNamedAndRemoveUntil(
        //       context, "/ui/success", (route) => false,
        //       arguments: {
        //         "id_cart": _idCart,
        //         "payment_type": _typePaymentName,
        //         "id_order": _idOrder,
        //         "cep": _cep.toString(),
        //         "estado": _state.toString(),
        //         "cidade": _city.toString(),
        //         "endereco": _address.toString(),
        //         "bairro": _nbh.toString(),
        //         "numero": _number.toString(),
        //         "complemento": _complement.toString(),
        //         "total_items": _cartValue,
        //         "freight_value": _freightValue,
        //         "total_value": _totalValue,
        //       });
        //
        // });
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> payWithTicketWithOutAddress(String idOrder,
      String totalValue) async {
    try {
      final body = {
        "id_pedido": idOrder,
        "id_usuario": await Preferences.getUserData()!.id,
        "tipo_pagamento": ApplicationConstant.TICKET_IN_TERM,
        "valor": totalValue,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.ADD_PAYMENT, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Payment.fromJson(_map[0]);

      if (response.status == "01") {
        setState(() {
          // Navigator.pushNamedAndRemoveUntil(
          //     context, "/ui/success", (route) => false,
          //     arguments: {
          //       "id_cart": _idCart,
          //       "payment_type": _typePaymentName,
          //       "id_order": _idOrder,
          //       "cep": _cep.toString(),
          //       "estado": _state.toString(),
          //       "cidade": _city.toString(),
          //       "endereco": _address.toString(),
          //       "bairro": _nbh.toString(),
          //       "numero": _number.toString(),
          //       "complemento": _complement.toString(),
          //       "total_items": _cartValue,
          //       "freight_value": _freightValue,
          //       "total_value": _totalValue,
          //     });

        });
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> payWithTicket(String idOrder,
      String totalValue,
      String cep,
      String state,
      String city,
      String address,
      String nbh,
      String number) async {
    try {
      final body = {
        "id_pedido": idOrder,
        "id_usuario": await Preferences.getUserData()!.id,
        "tipo_pagamento": ApplicationConstant.TICKET,
        "valor": totalValue,
        "cep": cep,
        "estado": state,
        "cidade": city,
        "endereco": address,
        "bairro": nbh,
        "numero": number,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.ADD_PAYMENT, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Payment.fromJson(_map[0]);

      if (response.status == "01") {
        // setState(() {
        //   Navigator.pushNamedAndRemoveUntil(
        //       context, "/ui/success", (route) => false,
        //       arguments: {
        //         "id_cart": _idCart,
        //         "payment_type": _typePaymentName,
        //         "id_order": _idOrder,
        //         "barCode": response.cod_barras,
        //         "cep": _cep.toString(),
        //         "estado": _state.toString(),
        //         "cidade": _city.toString(),
        //         "endereco": _address.toString(),
        //         "bairro": _nbh.toString(),
        //         "numero": _number.toString(),
        //         "complemento": _complement.toString(),
        //         "total_items": _cartValue,
        //         "freight_value": _freightValue,
        //         "total_value": _totalValue,
        //       });
        //
        // });
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> payWithPIX(String idOrder, String totalValue) async {
    try {
      final body = {
        "id_pedido": idOrder,
        "id_usuario": await Preferences.getUserData()!.id,
        "tipo_pagamento": ApplicationConstant.PIX,
        "valor": totalValue,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.ADD_PAYMENT, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Payment.fromJson(_map[0]);

      if (response.status == "01") {
        // Navigator.pushNamedAndRemoveUntil(
        //     context, "/ui/success", (route) => false,
        //     arguments: {
        //       "id_cart": _idCart,
        //       "base64": response.qrcode_64,
        //       "qrCodeClipboard": response.qrcode,
        //       "payment_type": _typePaymentName,
        //       "id_order": _idOrder,
        //       "cep": _cep.toString(),
        //       "estado": _state.toString(),
        //       "cidade": _city.toString(),
        //       "endereco": _address.toString(),
        //       "bairro": _nbh.toString(),
        //       "numero": _number.toString(),
        //       "complemento": _complement.toString(),
        //       "total_items": _cartValue,
        //       "freight_value": _freightValue,
        //       "total_value": _totalValue,
        //     });
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

/////////////////////////

  Future<Map<String, dynamic>> saveTask(String idFleet, String idEquip, String name, String desc, String checklist) async {
    try {
      final body = {
        "id_frota": idFleet,
        "id_equipamento": idEquip,
        "nome": name,
        "descricao": desc,
        "checklist": checklist,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.SAVE_TASK, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Task.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> updateTask(String idTask, String idFleet, String idEquip, String name, String desc, String checklist, String status) async {
    try {
      final body = {
        "id_tarefa": idTask,
        "id_frota": idFleet,
        "id_equipamento": idEquip,
        "nome": name,
        "descricao": desc,
        "checklist": checklist,
        "status": status,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.UPDATE_TASK, body);

      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Task.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> listTasks(String idFleet) async {
    try {
      final body = {
        "frota_id": idFleet,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_TASKS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Task.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }


  Future<List<Map<String, dynamic>>> listTaskId(String idTask) async {
    try {
      final body = {
        "tarefa_id": idTask,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_ID_TASK, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Task.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> deleteTask(String idTask) async {
    try {
      final body = {
        "id_tarefa": idTask,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.DELETE_TASK, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Task.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  //////////////////////////

  Future<Map<String, dynamic>> addTaskEmployee(String idTask, String idEmployee) async {
    try {
      final body = {
        "id_tarefa": idTask,
        "id_funcionario": idEmployee,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.SAVE_TASK_EMPLOYEE, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Task.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> listTaskEmployees(String idTask) async {
    try {
      final body = {
        "id_tarefa": idTask,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_TASK_EMPLOYEE, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Task.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> listTaskEmployeesAll(String idTask, String idCompany) async {
    try {
      final body = {
        "id_tarefa": idTask,
        "id_empresa": idCompany,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_TASK_EMPLOYEE_ALL, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Task.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> deleteTaskEmployee(String idTask, String idEmployee) async {
    try {
      final body = {
        "id_tarefa": idTask,
        "id_funcionario": idEmployee,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.DELETE_TASK_EMPLOYEE, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Task.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  ///////////////////////////////////

  Future<Map<String, dynamic>> saveComment(String idTask, String desc) async {
    try {
      final body = {
        "id_tarefa": idTask,
        "id_usuario": await Preferences.getUserData()!.id,
        "descricao": desc,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.SAVE_TASK_COMMENT, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Task.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> updateComment(String idComment, String desc) async {
    try {
      final body = {
        "id_comentario": idComment,
        "id_usuario": await Preferences.getUserData()!.id,
        "descricao": desc,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.UPDATE_TASK_COMMENT, body);

      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Task.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> listComments(String idTask) async {
    try {
      final body = {
        "id_tarefa": idTask,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_TASK_COMMENTS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Task.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> deleteComment(String idComment) async {
    try {
      final body = {
        "id_comentario": idComment,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.DELETE_TASK_COMMENT, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Task.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  ////////////////////////

  Future<Map<String, dynamic>> saveChecklist(String idTask) async {
    try {
      final body = {
        "id_tarefa": idTask,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.SAVE_TASK_CHECKLIST, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Task.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> saveChecklistItem(String idCheckList, String name) async {
    try {
      final body = {
        "id_checklist": idCheckList,
        "nome": name,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.SAVE_TASK_CHECKLIST_ITEMS, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Task.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> listChecklists(String idTask) async {
    try {
      final body = {
        "id_tarefa": idTask,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_TASK_CHECKLISTS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Task.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<List<Map<String, dynamic>>> listChecklistItems(String idChecklist) async {
    try {
      final body = {
        "id_checklist": idChecklist,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_TASK_CHECKLIST_ITEMS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Task.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> checkUncheckItem(String idChecklistItem) async {
    try {
      final body = {
        "id_checklist_item": idChecklistItem,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.CHECK_UNCHECK_ITEM, body);

      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Task.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> updateChecklistName(String idChecklist, String name) async {
    try {
      final body = {
        "id_checklist": idChecklist,
        "nome": name,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.UPDATE_TASK_CHECKLIST, body);

      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Task.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> deleteChecklist(String idChecklist) async {
    try {
      final body = {
        "id_checklist": idChecklist,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.DELETE_TASK_CHECKLIST, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Task.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> deleteChecklistItem(String idChecklistItem) async {
    try {
      final body = {
        "id_checklist_item": idChecklistItem,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.DELETE_TASK_CHECKLIST_ITEM, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Task.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  ////////////////////////////////////////////

  Future<List<Map<String, dynamic>>> listAttachments(String idTask) async {
    try {
      final body = {
        "tarefa_id": idTask,
        "token": ApplicationConstant.TOKEN,
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.LIST_ATTACHMENTS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = Task.fromJson(_map[0]);

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<Map<String, dynamic>> deleteAttachment(String idAttachment) async {
    try {
      final body = {
        "id_anexo": idAttachment,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.DELETE_ATTACHMENT, body);
      final parsedResponse = jsonDecode(json);

      print('HTTP_RESPONSE: $parsedResponse');

      final response = Task.fromJson(parsedResponse);

      return parsedResponse;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "Pesquisar", isVisibleBackButton: false),
      body:  RefreshIndicator(
              onRefresh: _pullRefresh,
              child:  Container())

    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      // listFavorites();
      _isLoading = false;
    });
  }
}
