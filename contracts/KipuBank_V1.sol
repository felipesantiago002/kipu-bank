
//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract KipuBank_V1 {

	/*///////////////////////
					Variables
	///////////////////////*/

    uint256 immutable i_bankCap;
    uint256 immutable i_maxRetiro;
	
	///@notice mapping para almacenar el valor en la boveda de cada usuario
	mapping(address usuario => uint256 valor) public s_banco;
	///@notice mapping para almacenar cantidad de retiros de cada usuario
	mapping(address usuario => uint256 valor) public s_retiros;
	///@notice mapping para almacenar cantidad de depositos de cada ususario
	mapping(address usuario => uint256 valor) public s_depositos;
	
	/*///////////////////////
						Events
	////////////////////////*/

	///@notice evento emitido cuando se realiza una retirada exitosa
	event RetiroExitoso(address cuenta, uint256 valor);

	///@notice evento emitido cuando se realiza un deposito exitoso
	event DepositoExitoso(address cuenta, uint256 valor);

	/*///////////////////////
						Errors
	///////////////////////*/

	///@notice error emitido cuando no alcanzan fondos
	error KipuBank_V1_FalloSaldoNoDisponible(uint256 saldo);

    ///@notice error emitido cuando falla el mandado de ETH
    error KipuBank_V1_FalloETH(bytes error);

    ///@notice error emitidcuando retiro supera el maximo umbral de maximo retiro establecido
    error KipuBank_V1_FalloMaxRetiro(uint256 m_valor);

    ///@notice error emitido cuando se supera el bankCap de depositos establecido
    error KipuBank_V1_FalloBankCap();

	
	/*///////////////////////
					Functions
	///////////////////////*/


	constructor(uint256 m_bankCap, uint256 m_maxRetiro){
        i_bankCap = m_bankCap;
        i_maxRetiro = m_maxRetiro;
	}
	
	///@notice función para recibir ether directamente
	
	
	/**
		*@notice función para recibir donaciones
		*@dev esta función debe sumar el valor donado por cada dirección a lo largo del tiempo
		*@dev esta función debe emitir un evento informando la donación.
	*/
	function depositar() public payable superaBankCap{

		s_banco[msg.sender] = s_banco[msg.sender] + msg.value;
		s_depositos[msg.sender] ++;
		emit DepositoExitoso(msg.sender, msg.value);
    }

	function retirar(uint256  m_valor) external noTieneSaldoDisponible(m_valor) superaUmbral(m_valor){

        s_banco[msg.sender] = s_banco[msg.sender] - m_valor;
		s_retiros[msg.sender]++;
        emit RetiroExitoso(msg.sender, m_valor);
		_transferirEth(m_valor);
		
    }
	
	/**
		*@notice función privada para realizar la transferencia del ether
		*@param m_valor El valor a ser transferido
		*@dev debe revertir si falla
	*/
	function _transferirEth(uint256 m_valor) private {
		(bool exito, bytes memory error) = msg.sender.call{value: m_valor}("");
		if(!exito) revert KipuBank_V1_FalloETH(error);
	}

    modifier noTieneSaldoDisponible(uint256 m_valor){
        if( s_banco[msg.sender]  < m_valor) revert KipuBank_V1_FalloSaldoNoDisponible(s_banco[msg.sender]);
        _;
    }

    modifier superaUmbral(uint256 m_valor){
        if (m_valor > i_maxRetiro)
		 revert KipuBank_V1_FalloMaxRetiro(m_valor);
        _;
    }

    modifier superaBankCap(){
        if (address(this).balance > i_bankCap)
		 revert KipuBank_V1_FalloBankCap();
		_;
    }
	function obtenerSaldo() external view returns (uint256) {
		return s_banco[msg.sender];
	}
	
	receive() external payable{
        depositar();
    }
	fallback() external payable{
		if (msg.value > 0) {
            depositar();
        }
	}
	

}


