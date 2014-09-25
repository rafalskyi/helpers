<?php
set_time_limit(0);
ini_set('memory_limit', '2000M');
ignore_user_abort(1);
ob_implicit_flush();
include_once("common.php");
@include_once("$Root/admin/config.php");
@include_once("$Root/classes/class.mysql_eresponder.php");

echo "\r\nPID = " . getmypid() . "\r\n";

function responseToClient($accept, $buffer)
{
  echo "Say client \"" . $buffer . "\"... ";
  $buffer =  $buffer . "\r\n";
  socket_write($accept, $buffer, strlen($buffer));
  echo "OK <br />";

  return true;
}

function getPoolId($login)
{
  $db = MySqlEresponder::slave();
  $sql = "SELECT PoolId FROM `smtp_pools` WHERE Username = '" . $login . "'";
  $poolId = $db->GetValue($sql);

  return $poolId;
}

function saveToDb($poolId, $mailFrom, $rcptTo, $messageData) {
  $db  = new MySqlEresponder();
  $sql = "INSERT INTO `loop_pmta` (`Id`, `PoolId`, `MailFrom`, `RcptTo`, `MessageData`) VALUES (NULL, '" . $poolId . "', '" . $mailFrom . "', '" . $rcptTo . "', '" . $messageData . "')";
  if($db->Query($sql)) {
    return true;
  }

  return false;
}

$address = '127.0.0.1';
$port    = 25;

echo "Creation socket ... \r\n";
$socket = socket_create(AF_INET, SOCK_STREAM, SOL_TCP);

if ($socket < 0) {
  echo "Error: " . socket_strerror(socket_last_error()) . "\r\n";
} else {
  echo "OK\r\n";
}

echo "Bind socket... \r\n";
$bind = socket_bind($socket, $address, $port);
socket_set_option($socket, SOL_SOCKET, SO_REUSEADDR, 1); //allow use one port for multi connect
if ($bind < 0) {
  echo "Error: " . socket_strerror(socket_last_error()) . "\r\n";
} else {
  echo "OK \r\n";
}

echo "Listen socket... ";
$listen = socket_listen($socket, 5);
if ($listen < 0) {
  echo "Error: " . socket_strerror(socket_last_error()) . "\r\n";
} else {
  echo "OK \r\n";
}

while (true) {
  $waitingAuth = false;
  $authLogin   = false;
  $authPass    = false;
  $waitinData  = false;

  $poolId      = '';
  $mailFrom    = '';
  $rcptTo      = '';
  $messageData = '';


  echo "Waiting...";
  $accept = socket_accept($socket);
  if ($accept < 0) {
    echo "Error: " . socket_strerror(socket_last_error()) . "\r\n";
    break;
  } else {
    echo "OK \r\n";
  }

  $msg = "220 LoopPMTA";
  echo "Sending response to client \"" . $msg . "\"... ";
  socket_write($accept, $msg."\r\n", strlen ($msg."\r\n"));
  echo "OK \r\n";

  while (true) {
    $awr = trim(socket_read($accept, 13337886720));
    if (false === $awr) {
      echo "Error: " . socket_strerror(socket_last_error()) . "\r\n";
      break 2;
    } else {
      if (trim($awr) == "") {
        break;
      } else {
        if ($awr == 'QUIT') {
          socket_close($accept);
          $answerToClient = "0";
          responseToClient($accept, $answerToClient);
          echo "Close <br />";
          break 1;
        }

        if (strpos($awr, 'EHLO') !== false) {
          $answerToClient = "250 $awr";
        }

        if (strpos($awr, 'MIME') !== false && $waitinData) {
          $messageData = $awr;
          saveToDb($poolId, $mailFrom, $rcptTo, $messageData);
          $answerToClient = "250 OK";
        }

        if (base64_decode($awr, true) && $waitingAuth && $authLogin && !$authPass) {
          $pass           = base64_decode($awr);
          $authPass       = true;
          $answerToClient = "235 $awr";
        }

        if (base64_decode($awr, true) && $waitingAuth && !$authPass) {
          echo "123";
          $login          = base64_decode($awr);
          $poolId = getPoolId($login);
          $authLogin      = true;
          $answerToClient = "334 " .  trim($awr);
        }

        if (strpos($awr, 'AUTH LOGIN') !== false) {
          $waitingAuth    = true;
          $answerToClient = "334 $awr";
        }

        if (strpos($awr, 'MAIL FROM') !== false) {
          $waitingAuth    = true;
          $answerToClient = "250 $awr";
        }
        if (strpos($awr, 'RCPT TO') !== false) {
          $waitingAuth    = true;
          $answerToClient = "250 $awr";
        }
        if (strpos($awr, 'DATA') !== false) {
          $waitinData     = true;
          $answerToClient = "354 $awr";
        }
        if (strpos($awr, 'MAIL FROM') !== false) {
          $mailFrom       = $awr;
          $answerToClient = "250 $awr";
        }
        if (strpos($awr, 'RCPT TO') !== false) {
          $rcptTo         = $awr;
          $answerToClient = "250 $awr";
        }

        responseToClient($accept, $answerToClient);
        $awr = '';
      }
    }
  }

}

if (isset($socket)) {
  echo "Close socket... ";
  socket_close($socket);
  echo "OK <br />";
}